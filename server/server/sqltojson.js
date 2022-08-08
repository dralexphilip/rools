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
            let sqlContent = allRools[y].toString().trim().split('where')[1].toUpperCase().trim()
            let maxD = maxDepth(sqlContent);
            if(maxD<2){
                let index = allRools[y].toString().indexOf("'")
                rool.id = allRools[y].toString().trim().substring(allRools[y].toString().indexOf("'"), index+8).replace("'", "")
                rool.description = rool.id
                rool.insertSql = allRools[y].toString().trim()
                rool.selectRules = processInsert(sqlContent)
                rool.depth = maxD
            }
        }
        else if(allRools[y].toString().includes('update', 0)){
            //rools[y-1].updateSql = allRools[y].toString().trim()
        }
        rools.push(rool)
    }
    
    select = rools.filter(el => Object.keys(el).length);
    return select;
}

function processInsert(sql){
   
    let rule = {
                    "combinator": "and",
                    "rules": []
                }
    sql = sql.trim()
    var a = [], r = [];
    for(var i=0; i < sql.length; i++){
        if(sql.charAt(i) == '('){
            a.push(i);
        }
        if(sql.charAt(i) == ')'){
            let lowSql = '('+sql.substring(a.pop()+1,i)+')'
            let lowSql1 = '('+sql.substring(a.pop()+1,i)+')'
            if(lowSql.includes('AND')||lowSql.includes('OR')){
                //if(lowSql.includes('(')&&lowSql.includes('IN'))
                    //lowSql.replace('(', '{').replace(')', '}')
                    r.push(lowSql);
                
            }
            else{
                lowSql = lowSql.replace('(', '{').replace(')', '}')
                r.push(lowSql);
                
                //if(sql.includes(lowSql.substring(1,lowSql.length-1))){
                    //sql = sql.replace(lowSql1, lowSql)
                //    console.log(lowSql)
                //}
            }
        }
    }  

    //r = r.filter(item => item.includes('AND', 0)||item.includes('OR', 0))
    

    
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
        rule.rules.push(exp[i])
    }

    
    rule.rules = processOperators(rule.rules)
    rule.rules.forEach(ru => {
        console.log(ru)
        //rule.rules.push(processInsert(ru))
    })

    return rule//shitshow(r[r.length-1]);
}
function maxDepth(s){
 
    let count = 0
    let st = []
    for(let i=0;i<s.length;i++){
        if (s[i] == '('){
            st.push(i) // pushing the bracket in the stack
        }
        else if (s[i] == ')'){
            if (count < st.length){
                count = st.length
            }
            // keeping track of the parenthesis and storing
            // it before removing it when it gets balanced
            st.pop()
            //console.log(st)
        }
    }
        
    return count
}

function processOperators(rules){
    for(var y = 0; y < rules.length; y++) {
        if(rules[y].toString().includes('=', 0)){
            let temp = rules[y].split('=')
            rules[y] = {}
            if(temp[0].trim().includes('COALESCE',0))
                rules[y].field = temp[0].trim().replace('COALESCE(','coalesce_').split(',')[0]
            else
                rules[y].field = temp[0].trim()
            rules[y].operator = 'equal'
            rules[y].value = temp[1].trim().split("'").join("")
        }
        else if(rules[y].toString().includes(' NOT LIKE ', 0)){
            let temp = rules[y].split(' NOT LIKE ')
            let value = temp[1].trim().split("'").join("")
            let begins_with = value.substring(0,1)
            let ends_with = value.substring(value.length-1)
            rules[y] = {}
            if(temp[0].trim().includes('COALESCE',0))
                rules[y].field = temp[0].trim().replace('COALESCE(','coalesce_').split(',')[0]
            else
                rules[y].field = temp[0].trim()
            if(begins_with=='%'&&ends_with=='%')
                rules[y].operator = 'not_contains'
            else if(begins_with=='%'&&ends_with!='%')
                rules[y].operator = 'does_not_end_with'
            else if(begins_with!='%'&&ends_with=='%')
                rules[y].operator = 'does_not_begin_with'
            rules[y].value = value.split("%").join("")
        }
        else if(rules[y].toString().includes(' LIKE ', 0)){
            let temp = rules[y].split(' LIKE ')
            let value = temp[1].trim().split("'").join("")
            let begins_with = value.substring(0,1)
            let ends_with = value.substring(value.length-1)
            rules[y] = {}
            if(temp[0].trim().includes('COALESCE',0))
                rules[y].field = temp[0].trim().replace('COALESCE(','coalesce_').split(',')[0]
            else
                rules[y].field = temp[0].trim()
            if(begins_with=='%'&&ends_with=='%')
                rules[y].operator = 'contains'
            else if(begins_with=='%'&&ends_with!='%')
                rules[y].operator = 'ends_with'
            else if(begins_with!='%'&&ends_with=='%')
                rules[y].operator = 'begins_with'
            rules[y].value = value.split("%").join("")
        }
        else if(rules[y].toString().includes(' NOT IN ', 0)){
            let temp = rules[y].toString().split("'").join("").split(' NOT IN ')
            rules[y] = {}
            rules[y].combinator = "or"
            rules[y].rules = []
            let values = temp[1].trim().substring(temp[1].trim().indexOf("(") + 1,temp[1].trim().lastIndexOf(")")).trim().split(',')
            let field = temp[0].trim()
            if(temp[0].trim().includes('COALESCE',0))
                field = temp[0].trim().replace('COALESCE(','coalesce_').split(',')[0]
            else
                field = temp[0].trim()
            let op = 'not_equal'
            values.forEach(v => {
                let rule = {}
                rule.field = field
                rule.operator = op
                rule.value = v
                rules[y].rules.push(rule)
            });
            
        }
        else if(rules[y].toString().includes(' IN ', 0)){
            let temp = rules[y].toString().split("'").join("").split(' IN ')
            rules[y] = {}
            rules[y].combinator = "or"
            rules[y].rules = []
            let values = temp[1].trim().substring(temp[1].trim().indexOf("(") + 1,temp[1].trim().lastIndexOf(")")).trim().split(',')
            let field = temp[0].trim()
            if(temp[0].trim().includes('COALESCE',0))
                field = temp[0].trim().replace('COALESCE(','coalesce_').split(',')[0]
            else
                field = temp[0].trim()
            let op = 'equal'
            values.forEach(v => {
                let rule = {}
                rule.field = field
                rule.operator = op
                rule.value = v
                rules[y].rules.push(rule)
            });
        }
        else if(rules[y].toString().includes(' <> ', 0)){
            let temp = rules[y].split(' <> ')
            rules[y] = {}
            if(temp[0].trim().includes('COALESCE',0))
                rules[y].field = temp[0].trim().replace('COALESCE(','coalesce_').split(',')[0]
            else
                rules[y].field = temp[0].trim()
            rules[y].operator = 'not_equal'
            rules[y].value = temp[1].trim().split("'").join("")
        }
    }
    return rules;
}

module.exports = { sqlToJson };