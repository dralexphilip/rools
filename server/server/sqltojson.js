const mappings = require('./mappings')
const complex_656 = require('./656.json')
const simple_545 = require('./545.json')
const simple_25 = require('./25.json')
const simple_26 = require('./26.json')
const simple_49 = require('./49.json')
const simple_121 = require('./121.json')
const simple_122 = require('./122.json')
const simple_154 = require('./154.json')
const simple_177 = require('./177.json')
const simple_184 = require('./184.json')
const simple_197 = require('./197.json')
const simple_198 = require('./198.json')
const simple_207 = require('./207.json')
const simple_208 = require('./208.json')
const simple_228 = require('./228.json')
const simple_264 = require('./264.json')
const simple_331 = require('./331.json')
const simple_363 = require('./363.json')
const simple_441 = require('./441.json')
const simple_617 = require('./617.json')
const simple_649 = require('./649.json')
const trading_partner_map = require('./tradingpartnerdata')
const maxIterationDepth = require('./config.json')

function sqlToJson() {
    let select = []
    const path = require("path");
    var fs = require('fs');
    var text = fs.readFileSync(path.resolve(__dirname, "complex.sql"), 'utf-8');

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
            
            //if(maxD<maxIterationDepth.maxDepth){
                let index = allRools[y].toString().indexOf("'")
                rool.tradePartner = "TPL_Ameriben"
                let roolId = allRools[y].toString().trim().substring(allRools[y].toString().indexOf("'"), index+8).replace("'", "")
                rool.id = roolId.split("RULE_").join("")
                rool.ruleId = roolId
                rool.description = roolId
                rool.status = 'Draft'
                rool.version = '1.0'
                rool.insertSql = allRools[y].toString().trim()
                rool.selectRule = processInsert(sqlContent)
                
                rool.depth = maxD
           // }
            
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
            //if(maxD<maxIterationDepth.maxDepth && rools[y-1].depth<maxIterationDepth.maxDepth){
                rools[y-1].updateSql = allRools[y].toString().trim()
                rools[y-1].updateRule = processUpdate(sqlContent)
                rools[y-1].updateDepth = maxD
                let updateConditions = processInsert(conditions)
                if(updateConditions.length > 1){
                    rools[y-1].updateCondition = updateConditions
                }
                else
                    rools[y-1].updateCondition = null
            //}
            
        }
        rools.push(rool)
    }
    //console.log(rools.length)
    select = rools.filter(el => Object.keys(el).length);
    select.map((e) => e.selectRule!=undefined?e.publish='S':e.publish='C');
    select.map(e => e.updateRule!=undefined?e.publish='S':e.publish='C');
    select.map(e => e.updateRule?.sets.length>0?e.publish='S':e.publish='C');

    //select.map((e) => e.ruleId==='RULE_54'?e.publish='C':null); //scenario not addressed
    //select.map((e) => e.ruleId==='RULE_69'?e.publish='C':null); //scenario not addressed
    //select.map((e) => e.ruleId==='RULE_462'?e.publish='C':null); //scenario not addressed
    //select.map((e) => {
        //e.ruleId==='RULE_72'?e.publish='C':null;
        //e.ruleId==='RULE_202'?e.publish='C':null;
        //e.ruleId==='RULE_217'?e.publish='C':null;
        //e.ruleId==='RULE_294'?e.publish='C':null;
        //e.ruleId==='RULE_347'?e.publish='C':null;
        //e.ruleId==='RULE_381'?e.publish='C':null;
        //e.ruleId==='RULE_388'?e.publish='C':null;
        //e.ruleId==='RULE_392'?e.publish='C':null;
    //});

    

    select.map((e) => {if(e.selectRule?.rules?.find(r=>r.field==='TRADING_PARTNER_CARRIER_NAME' && r.tradePartner)?.tradePartner){
                            e.tradePartner = e.selectRule.rules.find(r=>r.field==='TRADING_PARTNER_CARRIER_NAME' && r.tradePartner)?.tradePartner;
                            delete e.selectRule.rules.find(r=>r.field==='TRADING_PARTNER_CARRIER_NAME' && r.tradePartner)?.tradePartner
                            }
                         });
    select.map((e) => e.ruleId==='RULE_657'?e.tradePartner='TPL_CIGNA_EP':null);
    select.map((e) => e.ruleId==='RULE_40B'?e.id=41:null);

    select.map((e) => e.ruleId = parseInt(e.id));

    return select;
}

function processInsert(sql){   
    //if(sql.includes('PACIFICSOURCE%'))
    //    console.log(sql)
    
    let rule1 = {
                    "combinator": "or",
                    "rules": []
                }
    sql = sql.split(" AND ").join(" && ").split(" And ").join(" && ").split(" and ").join(" && ").trim()
    sql = sql.split(" OR ").join(" OROR ").split(" or ").join(" OROR ").split(" Or ").join(" OROR ").trim()
    //if(sql.includes('PACIFICSOURCE%'))
    //    console.log(sql)
    exp = sql.split(' && ');  
    //if(sql.includes('PACIFICSOURCE%'))
    //    console.log(exp)
    let rule = {
        "combinator": "and",
        "rules": []
    }    
    //rule.rules.push(roolLoop(exp))
    //console.log(rule)
    return roolLoop(exp)
}

function roolLoop(exp){
    let rule = {
        "combinator": "and",
        "rules": []
    }
    let subrule = {
        "combinator": "or",
        "rules": []
    }
    for(var i = 0; i < exp.length; i++) {
        exp[i] = exp[i].trim()
        
        if(exp[i].includes(' OROR ')){  
            exp[i] = exp[i].substring(
                exp[i].indexOf("(") + 1, 
                exp[i].lastIndexOf(")")
            );            
            let splitOrRools = exp[i].split(' OROR ');  
            let orProcessedRules = []
            for(var y = 0; y < splitOrRools.length; y++) {
                orProcessedRules = processOperators(splitOrRools[y])
                subrule.rules.push(processOperators(orProcessedRules))
            } 
            processOperators(subrule.rules)
            rule.rules.push(subrule)              
        }   
        else{
            exp[i] = processOperators([exp[i]]);
            rule.rules.push(exp[i][0]);
            
        }  
    } 
    return rule;
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

        //if(rules[y].includes('PACIFICSOURCE%')){
        //    console.log(exp)
        //}
        

        rules[y] = rules[y].toString().split("Coalesce").join("COALESCE").split("coalesce").join("COALESCE").trim()
        rules[y] = rules[y].toString().split(" Null ").join(" NULL ").split(" null ").join(" NULL ").trim()
        rules[y] = rules[y].toString().split(" NOT LIKE ").join(" NOTLIKKE ").split(" Not Like ").join(" NOTLIKKE ").split(" not like ").join(" NOTLIKKE ").trim()
        rules[y] = rules[y].toString().split(" LIKE ").join(" LIKKE ").split(" Like ").join(" LIKKE ").split(" like ").join(" LIKKE ").trim()
        rules[y] = rules[y].toString().split(" NOT IN ").join(" NOTINN ").split(" Not in ").join(" NOTINN ").split(" not In ").join(" NOTINN ").split(" Not In ").join(" NOTINN ").split(" not in ").join(" NOTINN ").trim()
        rules[y] = rules[y].toString().split(" IN ").join(" INN ").split(" In ").join(" INN ").split(" in ").join(" INN ").split(")IN").join(")INN").split("IN(").join("INN(").split(")in").join(")INN ").split("in(").join("INN(").trim()
        rules[y] = rules[y].toString().split("::TEXT").join("::TEXT").split("::Text").join("::TEXT").split("::text").join("::TEXT").trim()

        

        if(rules[y].toString().includes('=', 0)){
            let temp = rules[y].split('=')
            
            rules[y] = {"value": []}
            if(temp[0].trim().includes('COALESCE',0)){
                //console.log(rules[y])
                rules[y].field = temp[0].trim().replace('COALESCE(','').split(',')[0]+' - COALESCE' 
            }
            else
                rules[y].field = temp[0].trim()    
            
            let tempValue = temp[1].trim()

            if(tempValue.includes("{")&&tempValue.includes("}")){ //remove braces for plan_type values
                tempValue = tempValue.split("{").join("").split("}").join("")
            }

            if((!tempValue.includes("'")&&tempValue!="NULL")){     
                //console.log(tempValue)           
                rules[y].operator = 'equal to field'
                rules[y].value = [tempValue]
                //rules[y].value = tempValue
                //rules[y].value.push(tempValue)
            }
            else{
                rules[y].operator = 'equal to'
                tempValue = tempValue.substring(
                    tempValue.indexOf("'") + 1, 
                    tempValue.lastIndexOf("'")
                )
                if(tempValue.includes("''")){
                    tempValue = tempValue.replace("''", "'")
                }
                rules[y].value.push(tempValue)
            }
            
            if(rules[y].field == 'TRADING_PARTNER_CARRIER_NAME'&&(!tempValue.includes("'")&&tempValue!="NULL"))  {        //hardcoded carrier name uppercase            
                rules[y].fieldDisplayType = 'single select'
                //console.log(rules[y].value)
                if(rules[y].value)
                    rules[y].tradePartner =  trading_partner_map.trading_partner_map.find(m => m.carrierName === rules[y].value[0])?.tradePartner
            }
            else
                rules[y].fieldDisplayType = 'textbox'
        }
        else if(rules[y].toString().includes(' NOTLIKKE ', 0)){
            let temp = rules[y].split(' NOTLIKKE ')
            let value = temp[1].trim()
            value = value.substring(
                value.indexOf("'") + 1, 
                value.lastIndexOf("'")
            )
            if(value.includes("''")){
                value = value.replace("''", "'")
            }
            let begins_with = value.substring(0,1)
            let ends_with = value.substring(value.length-1)
            rules[y] = {"value": []}
            if(temp[0].trim().includes('COALESCE',0))
                rules[y].field = temp[0].trim().replace('COALESCE(','').split(',')[0]+' - COALESCE'    
            else
                rules[y].field = temp[0].split("::TEXT").join("").trim()  
            if(begins_with=='%'&&ends_with=='%')
                rules[y].operator = 'does not contain'
            else if(begins_with=='%'&&ends_with!='%')
                rules[y].operator = 'does not end with'
            else if(begins_with!='%'&&ends_with=='%')
                rules[y].operator = 'does not begin with'
            rules[y].value.push(value.split("%").join(""))
            rules[y].fieldDisplayType = 'textbox'
        }
        else if(rules[y].toString().includes(' LIKKE ')){
            let temp = rules[y].split(' LIKKE ')
            let value = temp[1].trim()
            value = value.substring(
                value.indexOf("'") + 1, 
                value.lastIndexOf("'")
            )
            if(value.includes("''")){
                value = value.replace("''", "'")
            }
            let begins_with = value.substring(0,1)
            let ends_with = value.substring(value.length-1)
            let rool = {"value": []}
            if(temp[0].trim().includes('COALESCE',0))
                rool.field = temp[0].trim().replace('COALESCE(','').split(',')[0]+' - COALESCE'    
            else
                rool.field = temp[0].split("::TEXT").join("").trim()  
            if(begins_with=='%'&&ends_with=='%')
                rool.operator = 'contains'
            else if(begins_with=='%'&&ends_with!='%')
                rool.operator = 'ends with'
            else if(begins_with!='%'&&ends_with=='%')
                rool.operator = 'begins with'
            rool.value.push(value.split("%").join(""))
            
            rool.fieldDisplayType = 'textbox'
            rules[y] = rool
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
                field = temp[0].split("::TEXT").join("").trim() 
            let op = 'not equal to'
            values.forEach(v => {
                let rule = {"value": []}
                rule.field = field 
                rule.operator = op
                if(v.includes("''")){
                    v = v.replace("''", "'")
                }
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
                field = temp[0].split("::TEXT").join("").trim() 
            let op = 'equal to'
            values.forEach(v => {
                let rule = {"value": []}
                rule.field = field 
                rule.operator = op
                v = v.trim().replace("'","")
                if(v.slice(-1)=="'")
                    v = v.replace(/.$/,"")          //replace last character
                if(v.includes("''")){
                    v = v.replace("''","'")
                }
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
            rules[y].operator = 'not equal to'
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
                    "defaultvalue": ""
                }
                rules[y].rootfield = temp[0].split("=")[0].trim()
                let tempValue = temp[1].trim()//temp[0].replace(rules[y].rootfield+' =', "").trim()//temp[1].trim()
                let endTemp = tempValue.trim().split('ELLSE')
                let setsql = endTemp[0].trim().split('CAASE').join("").trim()
                
                rules[y].defaultvalue = ""
                if (endTemp[1] != undefined && endTemp[1].toString().includes(" ENND"))
                    rules[y].defaultvalue = endTemp[1].split(" ENND").join("").split("'").join("").trim()
                else if(endTemp[1] != undefined)
                    rules[y].defaultvalue = endTemp[1].split("'").join("")  
                else
                    rules[y].defaultvalue = endTemp[1]
                if (rules[y].rootfield == rules[y].defaultvalue)
                    rules[y].defaultvalue = ""      //rules[y].defaultValue.toLowerCase()     
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
                    rules[y].fieldDisplayType = 'textbox'
                else{
                    rules[y].fieldDisplayType = 'textbox'   
                    //console.log(tempValue)    
                }         

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
                    let tempValue = temp[1].trim()   ////.split("'").join("")
                    //console.log(tempValue)
                    if(tempValue.includes("'"))
                        tempValue = tempValue.substring(
                            tempValue.indexOf("'") + 1, 
                            tempValue.lastIndexOf("'")
                        )
                    //console.log(tempValue)
                    if(tempValue.includes("''")){
                        tempValue = tempValue.replace("''", "'")
                    }
                    if(tempValue.includes("{")&&tempValue.includes("}")){ //remove braces for plan_type values
                        tempValue = tempValue.split("{").join("").split("}").join("")
                    }
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
            //console.log(value)
            
            rules[y] = {
                "when":{"value": []},
                "then":{"value": []},
                }
            rules[y].when.field = temp[0].split("::TEXT").join("").trim() 
            rules[y].then.field = rules[y].when.field 
            
            let tempValue = value.split("{").join("").split("}").join("").split(" THHEN ")
            
            ///**
            let begins_with = tempValue[0].trim().substring(0,1)
            let ends_with = tempValue[0].trim().substring(tempValue[0].trim().length-1)
            //console.log(tempValue)
                                                 
            if(begins_with=='%'&&ends_with=='%')
                rules[y].when.operator = 'contains'
            else if(begins_with=='%'&&ends_with!='%')
                rules[y].when.operator = 'ends with'
            else if(begins_with!='%'&&ends_with=='%')
                rules[y].when.operator = 'begins with'

             
            if (value.includes('||') && (value.includes('LEFFT') || value.includes('RIGGHT'))) {
                return rules = null
            }
            else if (value.includes('LEFFT') || value.includes('RIGGHT')) {
                //console.log('is it reaching he.........')
                //console.log(rules)
                return rules = null
            }
            rules[y].then.operator = 'equal to'

            rules[y].when.value.push(tempValue[0].split("%").join("").trim())
            if(tempValue[1]!=undefined){
                rules[y].then.value.push(tempValue[1].trim())
                if (tempValue[1].trim() == 'NULL') {
                    rules[y].then.operator = 'is null'
                    rules[y].then.value = null
                }
            }
            //*/
            //rules[y].operator = 'equal to'
            
            //else
                
            rules[y].when.fieldDisplayType = 'textbox'
            rules[y].then.fieldDisplayType = 'textbox'
            //console.log(rules)
        }
        else if(rules[y].toString().includes(' = ', 0)){
            let temp = rules[y].split(' = ')
            let value = temp[1].trim().split("'").join("").trim()
            //console.log(rules[y])
            
            rules[y] = {
                "when":{"value": []},
                "then":{"value": []},
                }
            rules[y].when.field = temp[0].split("::TEXT").join("").trim() 
            rules[y].then.field = rules[y].when.field 

            let tempValue = value.split("{").join("").split("}").join("").split(" THHEN ")
                        
            rules[y].when.operator = 'equal to'
            if (value.includes('||') && (value.includes('LEFFT') || value.includes('RIGGHT'))) {
                return rules = null
            }
            else if (value.includes('LEFFT') || value.includes('RIGGHT')) {
                return rules = null
            }
            rules[y].then.operator = rules[y].when.operator
            
            rules[y].when.value.push(tempValue[0].split("%").join("").trim())
            rules[y].then.value.push(tempValue[1].trim())

            if (tempValue[1].trim() == 'NULL') {
                rules[y].then.operator = 'is null'
                rules[y].then.value = null
            }
            
            rules[y].when.fieldDisplayType = 'textbox'
            rules[y].then.fieldDisplayType = 'textbox'
        }
        //let mappedField = mappings.mappings.find(mapping => mapping.oldField === rules[y].field)
        //if(mappedField)
        //    rules[y].field = mappedField.newField
    }
    return rules
}

module.exports = { sqlToJson };