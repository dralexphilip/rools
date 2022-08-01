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
   
    let select = {
                    "combinator": "and",
                    "rules": []
                }

    var a = [], r = [];
    for(var i=0; i < sql.length; i++){
        if(sql.charAt(i) == '('){
            a.push(i);
        }
        if(sql.charAt(i) == ')'){
            let lowSql = sql.substring(a.pop()+1,i)
            if(lowSql.includes('('))
                r.push(lowSql);
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
            exp[i] = processOperators(exp[i])            
        }
        else if(exp[i].includes('AND', 0)){
            exp[i] = exp[i].substring(
                exp[i].indexOf("(") + 1, 
                exp[i].lastIndexOf(")")
            );
            exp[i] = exp[i].split('AND');  
            exp[i] = processOperators(exp[i])            
        }        
        select.rules.push(exp[i])
    }

    
    select.rules = processOperators(select.rules)

    return select;
}

function processOperators(rules){
    for(var y = 0; y < rules.length; y++) {
        if(rules[y].toString().includes('=', 0)){
            let temp = rules[y].split('=')
            rules[y] = {}
            rules[y].field = temp[0].trim()
            rules[y].operator = 'equal'
            rules[y].value = temp[1].trim().split("'").join("")
        }
        else if(rules[y].toString().includes('NOT LIKE', 0)){
            let temp = rules[y].split('NOT LIKE')
            rules[y] = {}
            if(temp[0].trim().includes('COALESCE',0))
                rules[y].field = temp[0].trim().replace('COALESCE(','coalesce_').split(',')[0]
            rules[y].operator = 'not_contains'
            rules[y].value = temp[1].trim().split("'").join("").split("%").join("")
        }
        else if(rules[y].toString().includes('LIKE', 0)){
            let temp = rules[y].split('LIKE')
            rules[y] = {}
            if(temp[0].trim().includes('COALESCE',0))
                rules[y].field = temp[0].trim().replace('COALESCE(','coalesce_').split(',')[0]
            rules[y].operator = 'contains'
            rules[y].value = temp[1].trim().split("'").join("").split("%").join("")
        }
        else if(rules[y].toString().includes('NOT IN', 0)){
            let temp = rules[y].toString().split("'").join("").split('NOT IN')
            rules[y] = {}
            rules[y].field = temp[0].trim()
            rules[y].operator = 'not in'
            rules[y].value = temp[1].trim().substring(temp[1].trim().indexOf("(") + 1,temp[1].trim().lastIndexOf(")")).trim().split(', ')
        }
        else if(rules[y].toString().includes('IN', 0)){
            let temp = rules[y].toString().split("'").join("").split('IN')
            rules[y] = {}
            rules[y].field = temp[0].trim()
            rules[y].operator = 'in'
            rules[y].value = temp[1].trim().substring(temp[1].trim().indexOf("(") + 1,temp[1].trim().lastIndexOf(")")).trim().split(', ')
        }
    }
    return rules;
}

module.exports = { sqlToJson };