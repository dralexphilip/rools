const operators = require('./operators')

function sqlToJson(sql) {
    let select = {}
    const path = require("path");
    var fs = require('fs');
    var text = fs.readFileSync(path.resolve(__dirname, "sql.sql"), 'utf-8');
    
    
    var allRools = text.replace(/(\/\*[^*]*\*\/)|(\/\/[^*]*)|(--[^.].*)/gm, '').replace(/^\s*\n/gm, "").replace(/^\s+/gm, "")
    allRools = allRools.split(/\r?\n|\r/g).join(" ")
    //console.log(allRools)
    allRools = allRools.split(';')

    let rools = []
    for(var y = 0; y < allRools.length; y++) {
        let rool = {}
        if(allRools[y].toString().includes('insert', 0)){
            let sqlContent = allRools[y].toString().trim().split('where')[1].trim()
            let maxD = maxDepth(sqlContent);
            if(maxD<2){
                let index = allRools[y].toString().indexOf("'")
                //let date = new Date()
                //date = date.getFullYear() + "-" + (date.getMonth()+1) + "-" + date.getDate() + " " + date.getHours()+":"+date.getMinutes()+":"+date.getSeconds()+"Z"
                //rool.createdBy = "Sahadeo Bhogil"
                //rool.createdDate = date
                //rool.modifiedBy = "Sahadeo Bhogil"
                //rool.modifiedDate = date
                rool.tradePartner = ""
                let roolId = allRools[y].toString().trim().substring(allRools[y].toString().indexOf("'"), index+8).replace("'", "")
                rool.id = roolId.split("RULE_").join("")
                rool.ruleId = roolId
                rool.description = roolId
                rool.status = 'Draft'
                rool.version = '1.0'
                rool.insertSql = allRools[y].toString().trim()
                //console.log(sqlContent)
                rool.selectRule = processInsert(sqlContent.toUpperCase())
                
                rool.depth = maxD
            }
        }
        else if(allRools[y].toString().includes('update', 0)&&!allRools[y].toString().includes('cob_lead_staging', 0)){
            let updateStatement = allRools[y].toString().trim().split('where ')
            let sqlContent = updateStatement[0].toString().trim().split('set')[1].trim()
            let conditions = updateStatement[1].trim()
            let maxD = maxDepth(sqlContent);
            //rools[y-1].updateSql = allRools[y].toString().trim()
            if(maxD<2&&rools[y-1].depth<2){
                //rool.insertSql = allRools[y].toString().trim()
                rools[y-1].updateSql = allRools[y].toString().trim()
                rools[y-1].updateRule = processUpdate(sqlContent.toUpperCase())
                rools[y-1].updateDepth = maxD
                let updateConditions = processInsert(conditions.toUpperCase())
                if(updateConditions.length > 1){
                    rools[y-1].updateCondition = updateConditions
                }
                else
                    rools[y-1].updateCondition = null
            }
        }
        
        rools.push(rool)
    }
    
    select = rools.filter(el => Object.keys(el).length);
    select = select.filter(e => e.updateRule!=undefined)
    select = select.filter(e => e.updateRule.sets.length>0)
    select = select.map(({depth,updateDepth,...rest}) => ({...rest}));
    return select;
}

function processInsert(sql){   
    let rule = {
                    "combinator": "and",
                    "rules": []
                }
    sql = sql.trim()
    exp = sql.split('AND');  
    
    for(var i = 0; i < exp.length; i++) {
        exp[i] = exp[i].trim()
        if(exp[i].includes(' OR ', 0)||exp[i].includes(')OR', 0)||exp[i].includes('OR(', 0)||exp[i].includes('\\rOR', 0)||exp[i].includes('OR\\r', 0)){
            //console.log(exp[i])
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

    return rule
}

function processUpdate(sql){   
    let rule = {
                    "combinator": "set",
                    "sets": []
                }
    sql = sql.trim()
    exp = sql.split(',');  
    for(let i=0;i<exp.length;i++){
        if(!exp[i].includes('=')&&!exp[i].includes('||')){
            exp[i-1]=exp[i-1]+','+exp[i]
            exp.splice(i,1)
        }
        
    };   
    for(let i=0;i<exp.length;i++){
        if(!exp[i].includes('=')&&!exp[i].includes('||')){
            exp[i-1]=exp[i-1]+','+exp[i]
            exp.splice(i,1)
        }
        
    }; 

    let rules = processUpdateOperators(exp)  
    if(rules != null)
        rule.sets = rules  

    return rule
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
        }
    }
        
    return count
}

function getR(sql) {
    var a = [], r = [];
    for(var i=0; i < sql.length; i++){
        if(sql.charAt(i) == '('){
            a.push(i);
        }
        if(sql.charAt(i) == ')'){
            let lowSql = '('+sql.substring(a.pop()+1,i)+')'
            let lowSql1 = '('+sql.substring(a.pop()+1,i)+')'
            if(lowSql.includes('AND')||lowSql.includes('OR')){
                r.push(lowSql);
                
            }
            else{
                lowSql = lowSql.replace('(', '{').replace(')', '}')
                r.push(lowSql);
            }
        }
    } 
    return r
}

function processOperators(rules){
    for(var y = 0; y < rules.length; y++) {
        if(rules[y].toString().includes('=', 0)){
            let temp = rules[y].split('=')
            
            rules[y] = {"value": []}
            if(temp[0].trim().includes('COALESCE',0))
                rules[y].field = temp[0].trim().replace('COALESCE(','').split(',')[0].toLowerCase()+' - coalesce' //lower case changes
            else
                rules[y].field = temp[0].trim().toLowerCase()    //lower case changes
            let tempValue = temp[1].trim()
            if((!tempValue.includes("'")&&tempValue!="NULL")){                
                rules[y].operator = 'equal to field'
                rules[y].value.push(tempValue.toLowerCase())
            }
            else{
                rules[y].operator = 'equal'
                rules[y].value.push(tempValue.split("'").join(""))
            }
            
            if(rules[y].field == 'carrier_name'||(!tempValue.includes("'")&&tempValue!="NULL"))                        //lower case changes
                rules[y].fieldDisplayType = 'single select'
            else
                rules[y].fieldDisplayType = 'textbox'
        }
        else if(rules[y].toString().includes(' NOT LIKE ', 0)){
            let temp = rules[y].split(' NOT LIKE ')
            let value = temp[1].trim().split("'").join("")
            let begins_with = value.substring(0,1)
            let ends_with = value.substring(value.length-1)
            rules[y] = {"value": []}
            if(temp[0].trim().includes('COALESCE',0))
                rules[y].field = temp[0].trim().replace('COALESCE(','').split(',')[0].toLowerCase()+' - coalesce'    //lower case
            else
                rules[y].field = temp[0].trim().toLowerCase()   //lower case
            if(begins_with=='%'&&ends_with=='%')
                rules[y].operator = 'not contains'
            else if(begins_with=='%'&&ends_with!='%')
                rules[y].operator = 'does_not_end_with'
            else if(begins_with!='%'&&ends_with=='%')
                rules[y].operator = 'does_not_begin_with'
            rules[y].value.push(value.split("%").join(""))
            rules[y].fieldDisplayType = 'textbox'
        }
        else if(rules[y].toString().includes(' LIKE ', 0)){
            let temp = rules[y].split(' LIKE ')
            let value = temp[1].trim().split("'").join("")
            let begins_with = value.substring(0,1)
            let ends_with = value.substring(value.length-1)
            rules[y] = {"value": []}
            if(temp[0].trim().includes('COALESCE',0))
                rules[y].field = temp[0].trim().replace('COALESCE(','').split(',')[0].toLowerCase()+' - coalesce'    //lower case
            else
                rules[y].field = temp[0].trim().toLowerCase()   //lower case
            if(begins_with=='%'&&ends_with=='%')
                rules[y].operator = 'contains'
            else if(begins_with=='%'&&ends_with!='%')
                rules[y].operator = 'ends with'
            else if(begins_with!='%'&&ends_with=='%')
                rules[y].operator = 'begins with'
            rules[y].value.push(value.split("%").join(""))
            rules[y].fieldDisplayType = 'textbox'
        }
        else if(rules[y].toString().includes(' NOT IN ', 0)){
            let temp = rules[y].toString().split("'").join("").split(' NOT IN ')
            rules[y] = {}
            rules[y].combinator = "or"
            rules[y].rules = []
            let values = temp[1].trim().substring(temp[1].trim().indexOf("(") + 1,temp[1].trim().lastIndexOf(")")).trim().split(',')
            let field = temp[0].trim()
            if(temp[0].trim().includes('COALESCE',0))
                field = temp[0].trim().replace('COALESCE(','').split(',')[0].toLowerCase()+' - coalesce'
            else
                field = temp[0].trim()
            let op = 'not_equal'
            values.forEach(v => {
                let rule = {"value": []}
                rule.field = field.toLowerCase()    //lower case
                rule.operator = op
                rule.value.push(v.trim())
                rule.fieldDisplayType = 'textbox'
                rules[y].rules.push(rule)
            });
            
        }
        else if(rules[y].toString().includes(' IN ', 0) || rules[y].toString().includes('IN(', 0) || rules[y].toString().includes(')IN', 0)){
            
            let temp = rules[y].toString().split(/IN(.*)/s)
            
            rules[y] = {}
            rules[y].combinator = "or"
            rules[y].rules = []
            let values = temp[1].trim().substring(temp[1].trim().indexOf("(") + 1,temp[1].trim().lastIndexOf(")")).trim().split("',")
            
            let field = temp[0].trim()
            if(temp[0].trim().includes('COALESCE',0))
                field = temp[0].trim().replace('COALESCE(','').split(',')[0].toLowerCase()+' - coalesce'
            else
                field = temp[0].trim()
            let op = 'equal'
            values.forEach(v => {
                let rule = {"value": []}
                rule.field = field.toLowerCase()    //lower case
                rule.operator = op
                v = v.trim().replace("'","")
                if(v.slice(-1)=="'")
                    v = v.replace(/.$/,"")          //replace last character
                rule.value.push(v)
                rule.fieldDisplayType = 'textbox'
                rules[y].rules.push(rule)
            });
        }
        else if(rules[y].toString().includes(' <> ', 0)){
            let temp = rules[y].split(' <> ')
            rules[y] = {"value": []}
            if(temp[0].trim().includes('COALESCE',0))
                rules[y].field = temp[0].trim().replace('COALESCE(','').split(',')[0].toLowerCase()+' - coalesce'    //lower case
            else
                rules[y].field = temp[0].trim().toLowerCase()   //lower case
            rules[y].operator = 'not equal'
            rules[y].value.push(temp[1].trim().split("'").join(""))
            rules[y].fieldDisplayType = 'textbox'
        }
    }
    return rules;
}

function processUpdateOperators(rules) {
    for (var y = 0; y < rules.length; y++) {


        if (rules[y].toString().includes('=', 0)) {
            let temp = rules[y].split('=')
            let tempValue = temp[1].trim()
            if (tempValue.includes('CASE', 0)) {
                let endTemp = tempValue.trim().split('ELSE')
                let setsql = endTemp[0].trim().split('CASE').join("").trim()
                rules[y] = {
                    "combinator": "case",
                    "sets": [],
                    "rootfield": "",
                    "defaultValue": ""
                }
                rules[y].rootfield = temp[0].trim()
                if (endTemp[1] != undefined && endTemp[1].toString().includes("END"))
                    rules[y].defaultValue = endTemp[1].split("END").join("").trim()
                else
                    rules[y].defaultValue = endTemp[1]  //lower case for plan end
                if (rules[y].rootfield == rules[y].defaultValue)
                    rules[y].defaultValue = ""      //rules[y].defaultValue.toLowerCase()     //lower case
                rules[y].rootfield = rules[y].rootfield.toLowerCase()               //lower case
                let sets = processCase(setsql.split('WHEN ').filter(e => e))
                if(sets)
                    rules[y].sets = sets
                else
                    return rules = null
            }
            else {
                rules[y] = {
                    "field": "",
                    "operator": "",
                    "value": [],
                    "fieldDisplayType": ""
                }
                rules[y].field = temp[0].trim().toLowerCase()               //lower case 
                if((tempValue.includes("UPPER")&&tempValue.includes("("))||(!tempValue.includes("'")&&tempValue!="NULL"))
                    rules[y].fieldDisplayType = 'single select'
                else
                    rules[y].fieldDisplayType = 'textbox'
                if (tempValue.includes('||') && (tempValue.includes('LEFT') || tempValue.includes('RIGHT'))) {
                    return rules = null
                }
                else if (tempValue.includes('||') && (!tempValue.includes('LEFT') || !tempValue.includes('RIGHT'))) {
                    let value = tempValue.split('|| ')
                    if (value[0].includes("'")) {
                        rules[y].operator = 'prefix'
                        rules[y].value.push(value[0].split("'").join("").replace("(","").trim())
                        rules[y].value.push(value[1].replace(")","").trim().toLowerCase())
                    }
                    else {
                        rules[y].operator = 'suffix'
                        rules[y].value.push(value[1].split("'").join("").replace(")","").trim())
                        rules[y].value.push(value[0].replace("(","").trim().toLowerCase())
                    }
                }
                else if (tempValue.includes('LEFT') || tempValue.includes('RIGHT(')) {
                    
                    let value = tempValue.split(',')
                    if(value[0].includes('LEFT')){
                        rules[y].operator = 'left substring'
                        rules[y].value.push(value[1].replace(")", "").trim())
                    }
                    else if(value[0].includes('RIGHT')){
                        rules[y].operator = 'right substring'
                        rules[y].value.push(value[1].replace(")", "").trim())
                    }
                }
                else if((tempValue.includes("UPPER")&&tempValue.includes("("))||(!tempValue.includes("'")&&tempValue!="NULL")){                        
                    rules[y].operator = 'value of'
                    rules[y].value.push(tempValue.replace("UPPER", "").replace("(","").replace(")","").toLowerCase())
                    //console.log(tempValue)    
                }
                else {
                    let tempValue = temp[1].trim().split("'").join("")
                    if (tempValue == 'NULL') {
                        rules[y].operator = 'is null'
                        rules[y].value = null
                    }
                    else {
                        rules[y].operator = 'equal to'
                        rules[y].value.push(tempValue)
                    }

                }

            }
        }
    }
    return rules;
}

function processCase(rules){
    for(var y = 0; y < rules.length; y++) {
        if(rules[y].toString().includes(' LIKE ', 0)){
            let temp = rules[y].split(' LIKE ')
            let value = temp[1].trim().split("'").join("").trim()
            
            
            rules[y] = {"value": []}
            rules[y].field = temp[0].split("::TEXT").join("").trim().toLowerCase()  //lower case
            
            let tempValue = value.split("{").join("").split("}").join("").split(" THEN ")
            let begins_with = tempValue[0].trim().substring(0,1)
            let ends_with = tempValue[0].trim().substring(tempValue[0].trim().length-1)
            //console.log(tempValue)
            /**                                     operator dynamic for like statement
            if(begins_with=='%'&&ends_with=='%')
                rules[y].operator = 'contains'
            else if(begins_with=='%'&&ends_with!='%')
                rules[y].operator = 'ends_with'
            else if(begins_with!='%'&&ends_with=='%')
                rules[y].operator = 'begins_with'
            */
            rules[y].operator = 'equal to'
            if (value.includes('||') && (value.includes('LEFT') || value.includes('RIGHT'))) {
                return rules = null
            }
            else
                rules[y].value = value.split("%").join("").split("{").join("").split("}").join("").split(" THEN ")
            rules[y].fieldDisplayType = 'textbox'
        }
    }
    return rules
}

module.exports = { sqlToJson };