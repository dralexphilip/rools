const operators = require('./operators')

function sqlToJson(sql) {
    let select = {}
    var fs = require('fs');
    var text = fs.readFileSync("D:/React/rule-builder/rools/server/server/sql.sql", 'utf-8');
    var allRools = text.replace(/(\/\*[^*]*\*\/)|(\/\/[^*]*)|(--[^.].*)/gm, '').replace(/^\s*\n/gm, "").replace(/^\s+/gm, "").split(';')

    let rools = []
    for(var y = 0; y < allRools.length; y++) {
        let rool = {}
        if(allRools[y].toString().includes('insert', 0)){
            let index = allRools[y].toString().indexOf("'")
            rool.id = allRools[y].toString().trim().substring(allRools[y].toString().indexOf("'"), index+8).replace("'", "")
            rool.description = rool.id
            rool.insertSql = allRools[y].toString().trim()
            rool.selectRules = processInsert(rool.insertSql.split('where')[1].toUpperCase())
        }
        else if(allRools[y].toString().includes('update', 0)){
            rools[y-1].updateSql = allRools[y].toString().trim()
        }
        rools.push(rool)
    }
    
    select = rools.filter(el => Object.keys(el).length);
    return select;
}

function processInsert(sql){

    
    
    
    let combinator = {"combinator": "or",
                        "rules": []
                    }
    let select = {
                    "combinator": "and",
                    "rules": []
                }

    let rools = []

    var a = [], r = [];
    for(var i=0; i < sql.length; i++){
        if(sql.charAt(i) == '('){
            a.push(i);
        }
        if(sql.charAt(i) == ')'){
            if(sql.substring(a.pop()+1,i).includes('AND') || sql.substring(a.pop()+1,i).includes('OR'))
                r.push(sql.substring(a.pop()+1,i));
        }
    }  
    
        exp = sql.split('AND');
    
    
    for(var i = 0; i < exp.length; i++) {
        exp[i] = exp[i].trim()
        if(exp[i].includes('OR', 0)){
            exp[i] = exp[i].substring(
                exp[i].indexOf("(") + 1, 
                exp[i].lastIndexOf(")")
            );
            exp[i] = exp[i].split('OR');
            for(var j = 0; j < exp[i].length; j++) {
                combinator.rules.push(exp[i][j].trim())
                for(var k = 0; k < combinator.rules.length; k++) {
                    if(combinator.rules[k].toString().includes('IN', 0)){
                        let temp = combinator.rules[k].toString().split("'").join("").split('IN')
                        combinator.rules[k] = {}
                        combinator.rules[k].field = temp[0].trim()
                        combinator.rules[k].operator = 'in'
                        combinator.rules[k].value = temp[1].trim().substring(temp[1].trim().indexOf("(") + 1,temp[1].trim().lastIndexOf(")")).trim().split(', ')
                    }
                    else if(combinator.rules[k].toString().includes('=', 0)){
                        let temp = combinator.rules[k].split('=')
                        combinator.rules[k] = {}
                        combinator.rules[k].field = temp[0].trim()
                        combinator.rules[k].operator = 'equal'
                        combinator.rules[k].value = temp[1].trim().split("'").join("")
                    }
                }
            }
            
            exp[i] = combinator
            
        }

        
        select.rules.push(exp[i])
    }
    for(var y = 0; y < select.rules.length; y++) {
        if(select.rules[y].toString().includes('=', 0)){
            let temp = select.rules[y].split('=')
            select.rules[y] = {}
            select.rules[y].field = temp[0].trim()
            select.rules[y].operator = 'equal'
            select.rules[y].value = temp[1].trim().split("'").join("")
        }
        else if(select.rules[y].toString().includes('NOT LIKE', 0)){
            let temp = select.rules[y].split('NOT LIKE')
            select.rules[y] = {}
            if(temp[0].trim().includes('COALESCE',0))
                select.rules[y].field = temp[0].trim().replace('COALESCE(','coalesce_').split(',')[0]
            select.rules[y].operator = 'not_contains'
            select.rules[y].value = temp[1].trim().split("'").join("").split("%").join("")
        }
        else if(select.rules[y].toString().includes('IN', 0)){
            let temp = select.rules[y].toString().split("'").join("").split('IN')
            select.rules[y] = {}
            select.rules[y].field = temp[0].trim()
            select.rules[y].operator = 'in'
            select.rules[y].value = temp[1].trim().substring(temp[1].trim().indexOf("(") + 1,temp[1].trim().lastIndexOf(")")).trim().split(', ')
        }
    }

    return r;
}

module.exports = { sqlToJson };