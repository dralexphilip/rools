const mappings = require('./mappings')

function sqlToJson() {
    let select = []
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
            mappings.mappings.forEach(m => {                
                if(sqlContent.includes(m.oldField)){
                    sqlContent = sqlContent.split(m.oldField).join(m.newField)
                }                   
            });
            let maxD = maxDepth(sqlContent);
            if(maxD<2){
                let index = allRools[y].toString().indexOf("'")
                //let date = new Date()
                //date = date.getFullYear() + "-" + (date.getMonth()+1) + "-" + date.getDate() + " " + date.getHours()+":"+date.getMinutes()+":"+date.getSeconds()+"Z"
                //rool.createdBy = "Sahadeo Bhogil"
                //rool.createdDate = date
                //rool.modifiedBy = "Sahadeo Bhogil"
                //rool.modifiedDate = date
                rool.tradePartner = "TPL_Ameriben"
                let roolId = allRools[y].toString().trim().substring(allRools[y].toString().indexOf("'"), index+8).replace("'", "")
                rool.id = roolId.split("RULE_").join("")
                rool.ruleId = roolId
                rool.description = roolId
                rool.status = 'Draft'
                rool.version = '1.0'
                rool.insertSql = allRools[y].toString().trim()
                //console.log(sqlContent)
                rool.selectRule = processInsert(sqlContent)
                
                rool.depth = maxD
            }
            else{
                let index = allRools[y].toString().indexOf("'")
                rool.tradePartner = "TPL_Ameriben"
                let roolId = allRools[y].toString().trim().substring(allRools[y].toString().indexOf("'"), index+8).replace("'", "")
                rool.id = roolId.split("RULE_").join("")
                rool.ruleId = roolId
                rool.description = roolId
                rool.status = 'Draft'
                rool.version = '1.0'
                rool.insertSql = allRools[y].toString().trim()
                rool.depth = maxD
            }
        }
        else if(allRools[y].toString().includes('update', 0)&&!allRools[y].toString().includes('cob_lead_staging', 0)){
            let updateStatement = allRools[y].toString().trim().split('where ')
            let sqlContent = updateStatement[0].toString().trim().split('set')[1].trim()
            mappings.mappings.forEach(m => {                
                if(sqlContent.includes(m.oldField)){
                    sqlContent = sqlContent.split(m.oldField).join(m.newField)
                }                    
            });
            let conditions = updateStatement[1].trim()
            let maxD = maxDepth(sqlContent);
            //rools[y-1].updateSql = allRools[y].toString().trim()
            if(maxD<2&&rools[y-1].depth<2){
                //rool.insertSql = allRools[y].toString().trim()
                rools[y-1].updateSql = allRools[y].toString().trim()
                rools[y-1].updateRule = processUpdate(sqlContent)
                rools[y-1].updateDepth = maxD
                let updateConditions = processInsert(conditions)
                if(updateConditions.length > 1){
                    rools[y-1].updateCondition = updateConditions
                }
                else
                    rools[y-1].updateCondition = null
                //rools[y-1].publish = true
            }
            else {
                
                //rool.insertSql = allRools[y].toString().trim()
                rools[y-1].updateSql = allRools[y].toString().trim()
                rools[y-1].updateDepth = maxD
                //rools[y-1].publish = false
                //console.log('other rools', rools[y-1])
            }
        }
        rools.push(rool)
    }
    console.log(rools.length)
    select = rools.filter(el => Object.keys(el).length);
    console.log(select.length)
    select.map((e) => e.selectRule!=undefined?e.publish='S':e.publish='C')
    console.log(select.length)
    select.map(e => e.updateRule!=undefined?e.publish='S':e.publish='C')
    console.log(select.length)
    select.map(e => e.updateRule?.sets.length>0?e.publish='S':e.publish='C')
    console.log(select.length)
    
    //select = select.map(({depth,updateDepth,...rest}) => ({...rest}));
    return select;
}

function processInsert(sql){   
    let rule = {
                    "combinator": "and",
                    "rules": []
                }
    sql = sql.split(" AND ").join(" && ").split(" And ").join(" && ").split(" and ").join(" && ").trim()
    sql = sql.split(" OR ").join(" OROR ").split(" or ").join(" OROR ").split(" Or ").join(" OROR ").trim()
    //console.log(sql)
    exp = sql.split(' && ');  
    
    for(var i = 0; i < exp.length; i++) {
        exp[i] = exp[i].trim()
        if(exp[i].includes(' OROR ')){
            //console.log(exp[i])
            exp[i] = exp[i].substring(
                exp[i].indexOf("(") + 1, 
                exp[i].lastIndexOf(")")
            );
            exp[i] = exp[i].split(' OROR ');  
            exp[i] = processOperators(exp[i])            
        }
        else if(exp[i].includes(' && ')){
            exp[i] = exp[i].substring(
                exp[i].indexOf("(") + 1, 
                exp[i].lastIndexOf(")")
            );
            exp[i] = exp[i].split(' && ');  
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

        rules[y] = rules[y].toString().split(" Coalesce ").join(" COALESCE ").split(" coalesce ").join(" COALESCE ").trim()
        rules[y] = rules[y].toString().split(" Null ").join(" NULL ").split(" null ").join(" NULL ").trim()
        rules[y] = rules[y].toString().split(" NOT LIKE ").join(" NOTLIKKE ").split(" Not Like ").join(" NOTLIKKE ").split(" not like ").join(" NOTLIKKE ").trim()
        rules[y] = rules[y].toString().split(" LIKE ").join(" LIKKE ").split(" Like ").join(" LIKKE ").split(" like ").join(" LIKKE ").trim()
        rules[y] = rules[y].toString().split(" NOT IN ").join(" NOTINN ").split(" Not in ").join(" NOTINN ").split(" not In ").join(" NOTINN ").split(" Not In ").join(" NOTINN ").split(" not in ").join(" NOTINN ").trim()
        rules[y] = rules[y].toString().split(" IN ").join(" INN ").split(" In ").join(" INN ").split(" in ").join(" INN ").split(")IN").join(")INN").split("IN(").join("INN(").split(")in").join(")INN ").split("in(").join("INN(").trim()

        if(rules[y].toString().includes('=', 0)){
            let temp = rules[y].split('=')
            
            rules[y] = {"value": []}
            if(temp[0].trim().includes('COALESCE',0))
                rules[y].field = temp[0].trim().replace('COALESCE(','').split(',')[0]+' - COALESCE' 

            else
                rules[y].field = temp[0].trim()    
            let tempValue = temp[1].trim()
            if((!tempValue.includes("'")&&tempValue!="NULL")){                
                rules[y].operator = 'equal to field'
                rules[y].value.push(tempValue)
            }
            else{
                rules[y].operator = 'equal to'
                rules[y].value.push(tempValue.split("'").join(""))
            }
            
            if(rules[y].field == 'CARRIER_NAME'||(!tempValue.includes("'")&&tempValue!="NULL"))          //hardcoded carrier name uppercase            
                rules[y].fieldDisplayType = 'single select'
            else
                rules[y].fieldDisplayType = 'textbox'
        }
        else if(rules[y].toString().includes(' NOTLIKKE ', 0)){
            let temp = rules[y].split(' NOTLIKKE ')
            let value = temp[1].trim().split("'").join("")
            let begins_with = value.substring(0,1)
            let ends_with = value.substring(value.length-1)
            rules[y] = {"value": []}
            if(temp[0].trim().includes('COALESCE',0))
                rules[y].field = temp[0].trim().replace('COALESCE(','').split(',')[0]+' - COALESCE'    
            else
                rules[y].field = temp[0].trim()  
            if(begins_with=='%'&&ends_with=='%')
                rules[y].operator = 'not contains'
            else if(begins_with=='%'&&ends_with!='%')
                rules[y].operator = 'does_not_end_with'
            else if(begins_with!='%'&&ends_with=='%')
                rules[y].operator = 'does_not_begin_with'
            rules[y].value.push(value.split("%").join(""))
            rules[y].fieldDisplayType = 'textbox'
        }
        else if(rules[y].toString().includes(' LIKKE ', 0)){
            let temp = rules[y].split(' LIKKE ')
            let value = temp[1].trim().split("'").join("")
            let begins_with = value.substring(0,1)
            let ends_with = value.substring(value.length-1)
            rules[y] = {"value": []}
            if(temp[0].trim().includes('COALESCE',0))
                rules[y].field = temp[0].trim().replace('COALESCE(','').split(',')[0]+' - COALESCE'    
            else
                rules[y].field = temp[0].trim() 
            if(begins_with=='%'&&ends_with=='%')
                rules[y].operator = 'contains'
            else if(begins_with=='%'&&ends_with!='%')
                rules[y].operator = 'ends with'
            else if(begins_with!='%'&&ends_with=='%')
                rules[y].operator = 'begins with'
            rules[y].value.push(value.split("%").join(""))
            rules[y].fieldDisplayType = 'textbox'
        }
        else if(rules[y].toString().includes(' NOTINN ', 0)){
            let temp = rules[y].toString().split("'").join("").split(' NOTINN ')
            rules[y] = {}
            rules[y].combinator = "or"
            rules[y].rules = []
            let values = temp[1].trim().substring(temp[1].trim().indexOf("(") + 1,temp[1].trim().lastIndexOf(")")).trim().split(',')
            let field = temp[0].trim()
            if(temp[0].trim().includes('COALESCE',0))
                field = temp[0].trim().replace('COALESCE(','').split(',')[0]+' - COALESCE'
            else
                field = temp[0].trim()
            let op = 'not_equal'
            values.forEach(v => {
                let rule = {"value": []}
                rule.field = field 
                rule.operator = op
                rule.value.push(v.trim())
                rule.fieldDisplayType = 'textbox'
                rules[y].rules.push(rule)
            });
            
        }
        else if(rules[y].toString().includes(' INN ', 0) || rules[y].toString().includes('INN(', 0) || rules[y].toString().includes(')INN', 0)){
            
            let temp = rules[y].toString().split(/INN(.*)/s)
            //console.log(temp)
            
            rules[y] = {}
            rules[y].combinator = "or"
            rules[y].rules = []
            let values = temp[1].trim().substring(temp[1].trim().indexOf("(") + 1,temp[1].trim().lastIndexOf(")")).trim().split("',")
            
            let field = temp[0].trim()
            if(temp[0].trim().includes('COALESCE',0))
                field = temp[0].trim().replace('COALESCE(','').split(',')[0]+' - COALESCE'
            else
                field = temp[0].trim()
            let op = 'equal to'
            values.forEach(v => {
                let rule = {"value": []}
                rule.field = field 
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
                rules[y].field = temp[0].trim().replace('COALESCE(','').split(',')[0]+' - COALESCE'    
            else
                rules[y].field = temp[0].trim() 
            rules[y].operator = 'not equal'
            rules[y].value.push(temp[1].trim().split("'").join(""))
            rules[y].fieldDisplayType = 'textbox'
        }
        //let mappedField = mappings.mappings.find(mapping => mapping.oldField === rules[y].field)
        //if(mappedField)
        //    rules[y].field = mappedField.newField
    }
    return rules;
}

function processUpdateOperators(rules) {
    for (var y = 0; y < rules.length; y++) {

        rules[y] = rules[y].toString().split(" CASE ").join(" CAASE ").split(" Case ").join(" CAASE ").split(" case ").join(" CAASE ").trim()
        rules[y] = rules[y].toString().split("ELSE").join("ELLSE").split("Else").join("ELLSE").split("else").join("ELLSE").trim()
        rules[y] = rules[y].toString().split(" END").join(" ENND").split(" End").join(" ENND").split(" end").join(" ENND").trim()
        rules[y] = rules[y].toString().split("WHEN ").join("WHHEN ").split("When ").join("WHHEN ").split("when").join("WHHEN ").trim()
        rules[y] = rules[y].toString().split("UPPER(").join("UPPPER(").split("UPPER (").join("UPPPER(").split("upper(").join("UPPPER(").split("upper (").join("UPPPER(").trim()
        rules[y] = rules[y].toString().split("LEFT(").join("LEFFT(").split("LEFT (").join("LEFFT(").split("Left(").join("LEFFT(").split("Left (").join("LEFFT(").split("left(").join("LEFFT(").split("left (").join("LEFFT(").trim()
        rules[y] = rules[y].toString().split("RIGHT(").join("RIGGHT(").split("RIGHT (").join("RIGGHT(").split("Right(").join("RIGGHT(").split("Right (").join("RIGGHT(").split("right(").join("RIGGHT(").split("right (").join("RIGGHT(").trim()
        rules[y] = rules[y].toString().split("Null").join("NULL").split("Null").join("NULL").split("null").join("NULL").trim()
        //if (rules[y].toString().includes('=', 0)) {
            
            if (rules[y].toString().includes(' CAASE ', 0)) {
                let temp = rules[y].split(' CAASE ')
                rules[y] = {
                    "combinator": "case",
                    "sets": [],
                    "rootfield": "",
                    "defaultValue": ""
                }
                rules[y].rootfield = temp[0].split("=")[0].trim()
                let tempValue = temp[1].trim()//temp[0].replace(rules[y].rootfield+' =', "").trim()//temp[1].trim()
                let endTemp = tempValue.trim().split('ELLSE')
                let setsql = endTemp[0].trim().split('CAASE').join("").trim()
                
                rules[y].defaultValue = ""
                if (endTemp[1] != undefined && endTemp[1].toString().includes(" ENND"))
                    rules[y].defaultValue = endTemp[1].split(" ENND").join("").split("'").join("").trim()
                else if(endTemp[1] != undefined)
                    rules[y].defaultValue = endTemp[1].split("'").join("")  
                else
                    rules[y].defaultValue = endTemp[1]
                if (rules[y].rootfield == rules[y].defaultValue)
                    rules[y].defaultValue = ""      //rules[y].defaultValue.toLowerCase()     
                rules[y].rootfield = rules[y].rootfield              
                let sets = processCase(setsql.split('WHHEN ').filter(e => e))
                if(sets)
                    rules[y].sets = sets
                else
                    return rules = null
            }
            else {
                let temp = rules[y].split('=')
                let tempValue = temp[1].trim()
                rules[y] = {
                    "field": "",
                    "operator": "",
                    "value": [],
                    "fieldDisplayType": ""
                }
                rules[y].field = temp[0].trim() 
                if((tempValue.includes("UPPPER")&&tempValue.includes("("))||(!tempValue.includes("'")&&tempValue!="NULL"))
                    rules[y].fieldDisplayType = 'single select'
                else
                    rules[y].fieldDisplayType = 'textbox'
                if (tempValue.includes('||') && (tempValue.includes('LEFFT') || tempValue.includes('RIGGHT'))) {
                    return rules = null
                }
                else if (tempValue.includes('||') && (!tempValue.includes('LEFFT') || !tempValue.includes('RIGGHT'))) {
                    let value = tempValue.split('|| ')
                    if (value[0].includes("'")) {
                        rules[y].operator = 'prefix'
                        rules[y].value.push(value[0].split("'").join("").replace("(","").trim())
                        rules[y].value.push(value[1].replace(")","").trim())
                    }
                    else {
                        rules[y].operator = 'suffix'
                        rules[y].value.push(value[1].split("'").join("").replace(")","").trim())
                        rules[y].value.push(value[0].replace("(","").trim())
                    }
                }
                else if (tempValue.includes('LEFFT') || tempValue.includes('RIGGHT(')) {
                    
                    let value = tempValue.split(',')
                    if(value[0].includes('LEFFT')){
                        rules[y].operator = 'left substring'
                        rules[y].value.push(value[1].replace(")", "").trim())
                    }
                    else if(value[0].includes('RIGGHT')){
                        rules[y].operator = 'right substring'
                        rules[y].value.push(value[1].replace(")", "").trim())
                    }
                }
                else if((tempValue.includes("UPPPER")&&tempValue.includes("("))||(!tempValue.includes("'")&&tempValue!="NULL")){                        
                    rules[y].operator = 'value of'
                    rules[y].value.push(tempValue.replace("UPPPER", "").replace("(","").replace(")",""))
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
        //}
        //let mappedField = mappings.mappings.find(mapping => mapping.oldField === rules[y].field)
        //if(mappedField)
        //    rules[y].field = mappedField.newField
        //let mappedRootField = mappings.mappings.find(mapping => mapping.oldField === rules[y].rootfield)
        //if(mappedRootField)
        //    rules[y].rootfield = mappedRootField.newField
    }
    return rules;
}

function processCase(rules){
    for(var y = 0; y < rules.length; y++) {
        rules[y] = rules[y].toString().split(" LIKE ").join(" LIKKE ").split(" Like ").join(" LIKKE ").split(" like ").join(" LIKKE ").trim()
        rules[y] = rules[y].toString().split("::TEXT").join("::TEXT").split("::Text").join("::TEXT").split("::text").join("::TEXT").trim()
        rules[y] = rules[y].toString().split(" THEN ").join(" THHEN ").split(" Then ").join(" THHEN ").split(" then").join(" THHEN ").trim()
        rules[y] = rules[y].toString().split("LEFT(").join("LEFFT(").split("LEFT (").join("LEFFT(").split("Left(").join("LEFFT(").split("Left (").join("LEFFT(").split("left(").join("LEFFT(").split("left (").join("LEFFT(").trim()
        rules[y] = rules[y].toString().split("RIGHT(").join("RIGGHT(").split("RIGHT (").join("RIGGHT(").split("Right(").join("RIGGHT(").split("Right (").join("RIGGHT(").split("right(").join("RIGGHT(").split("right (").join("RIGGHT(").trim()
        
        if(rules[y].toString().includes(' LIKKE ', 0)){
            let temp = rules[y].split(' LIKKE ')
            let value = temp[1].trim().split("'").join("").trim()
            
            
            rules[y] = {"value": []}
            rules[y].field = temp[0].split("::TEXT").join("").trim() 
            
            let tempValue = value.split("{").join("").split("}").join("").split(" THHEN ")
            /**
            let begins_with = tempValue[0].trim().substring(0,1)
            let ends_with = tempValue[0].trim().substring(tempValue[0].trim().length-1)
            //console.log(tempValue)
                                                 operator dynamic for like statement
            if(begins_with=='%'&&ends_with=='%')
                rules[y].operator = 'contains'
            else if(begins_with=='%'&&ends_with!='%')
                rules[y].operator = 'ends_with'
            else if(begins_with!='%'&&ends_with=='%')
                rules[y].operator = 'begins_with'
            */
            rules[y].operator = 'equal to'
            if (value.includes('||') && (value.includes('LEFFT') || value.includes('RIGGHT'))) {
                return rules = null
            }
            else if (value.includes('LEFFT') || value.includes('RIGGHT')) {
                return rules = null
            }
            else
                rules[y].value = value.split("%").join("").split("{").join("").split("}").join("").split(" THHEN ")
            rules[y].fieldDisplayType = 'textbox'
        }
        else if(rules[y].toString().includes(' = ', 0)){
            let temp = rules[y].split(' = ')
            let value = temp[1].trim().split("'").join("").trim()
            //console.log(rules[y])
            
            rules[y] = {"value": []}
            rules[y].field = temp[0].split("::TEXT").join("").trim() 
                        
            rules[y].operator = 'equal to'
            if (value.includes('||') && (value.includes('LEFFT') || value.includes('RIGGHT'))) {
                return rules = null
            }
            else if (value.includes('LEFFT') || value.includes('RIGGHT')) {
                return rules = null
            }
            else
                rules[y].value = value.split("%").join("").split("{").join("").split("}").join("").split(" THHEN ")
            rules[y].fieldDisplayType = 'textbox'
        }
        //let mappedField = mappings.mappings.find(mapping => mapping.oldField === rules[y].field)
        //if(mappedField)
        //    rules[y].field = mappedField.newField
    }
    return rules
}

module.exports = { sqlToJson };