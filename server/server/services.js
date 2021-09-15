const operators = require('./operators')

function sqlQuery(qr) {
    let exp = '';

    for (const obj of qr.rules) {

        if (obj.field) {
            let field = obj.field;         
            const numCheck = field.substring(field.length - 1);
            if (numCheck === '1'){
                field = field.substring(0, field.length - 1);
            }
            else if(numCheck === '2' || numCheck === '3'){
                field = "coalesce("+field.substring(0, field.length - 1)+", '')";
            }
            let operator = obj.operator;            
            operator = operators.operators.find(o=> (o.value === obj.operator)).symbol;

            let value = obj.value;
            if (typeof obj.value != 'boolean') {
                if (Array.isArray(obj.value)) {
                    let conval = '';
                    obj.value.forEach(val => {
                        conval = conval + " '" + val + "',";
                    });
                    value = '(' + conval + ')';
                }
                else if (obj.value != null) {
                    if(obj.operator === 'equal' || obj.operator === 'not_equal')
                        value = `'${obj.value}'`;
                    else if(obj.operator === 'contains' || obj.operator === 'not_contains')
                        value = `'%${obj.value}%'`;
                    else if(obj.operator === 'begins_with')
                        value = `'${obj.value}%'`;
                    else if(obj.operator === 'ends_with')
                        value = `'%${obj.value}'`;
                }
                else {
                    value = "";
                }
            }
            exp = `${exp} ${field} ${operator} ${value} ` + qr.combinator;
        }
        else if (obj.rules) {
            exp = `${exp} (${sqlQuery(obj)}) ` + qr.combinator;
        }
    }
    if(exp.substring(exp.length - 2) === "or")
        exp = exp.substring(0, exp.length - 2);
    else if(exp.substring(exp.length - 3) === "and")
        exp = exp.substring(0, exp.length - 3);
    return exp;
}

function setConditions(qr) {
    let exp = '';

    for (const obj of qr.sets) {
        if (obj.field) {
            let field = obj.field;
            const numCheck = field.substring(field.length - 1);
            if (numCheck === '1' || numCheck === '3'){
                field = field.substring(0, field.length - 1);
            }
            let operator = obj.operator;            
            operator = operators.operators.find(o=> (o.value === obj.operator)).symbol;            
            let value = obj.value;
            if (typeof obj.value != 'boolean') {
                if (Array.isArray(obj.value)) {
                    let conval = '';
                    obj.value.forEach(val => {
                        conval = conval + " '" + val + "',";
                    });
                    value = '(' + conval + ')';
                }
                else if (obj.value != null) {
                    if(obj.operator === 'equal' || obj.operator === 'not_equal')
                        value = `'${obj.value}'`;
                    else if(obj.operator === 'contains' || obj.operator === 'not_contains')
                        value = `'%${obj.value}%'`;
                    else if(obj.operator === 'begins_with')
                        value = `'${obj.value}%'`;
                    else if(obj.operator === 'ends_with')
                        value = `'%${obj.value}'`;
                    else if(obj.operator === 'equals')
                        value = `'${obj.value}'`;
                    else if(obj.operator === 'left')
                        value = `left(${obj.field},${obj.value})`;
                    else if(obj.operator === 'right')
                        value = `right(${obj.field},${obj.value})`;
                    else if(obj.operator === 'substring')
                        value = `substring(${obj.field},${obj.value})`;
                }
                else {
                    value = "NULL";
                }
            }
            
            if (obj.tfield){
                exp = ` ${exp} when ${field} ${operator} ${value} then = '{${obj.tvalue}}' `;
            }
            else 
                exp = `${exp} ${field} ${operator} ${value +','} `;
        }
        else if (obj.sets) {
            if (obj.combinator === 'case'){
                let cfield = obj.sets[0].field;
                const numCheck = cfield.substring(cfield.length - 1);
                if (numCheck === '1' || numCheck === '3'){
                    cfield = cfield.substring(0, cfield.length - 1);
                }
                exp =  ` ${exp }${cfield} = ${obj.combinator} ${setConditions(obj)} else ${cfield} end `;
            }
        }
    }
    if(exp.substring(exp.length - 2) === "set")
        exp = exp.substring(0, exp.length - 2);
    else if(exp.substring(exp.length - 4) === "case")
        exp = exp.substring(0, exp.length - 4);
    return exp;
}

function ruleQuery(query){
    let queryJson = {};
    if(query.selectRules){
        queryJson['selectRules'] = sqlQuery(query.selectRules);
    }
    if(query.updateConditions){
        queryJson['updateConditions'] = sqlQuery(query.updateConditions);
    }
    if(query.updateRules){
        queryJson['updateRules'] = setConditions(query.updateRules);
    }

    return queryJson;
}

module.exports = { ruleQuery };