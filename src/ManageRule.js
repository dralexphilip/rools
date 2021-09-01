import React, { Component } from 'react';
import QueryBuilder from "./QueryBuilder";
import ruleoptions from './filters.json'
import rules from './rules.json'

export default class ManageRule extends Component {

    filters = ruleoptions;
    state={
        query: {
            combinator: "and",
            rules: [
                {
                    field: "carrier_name",
                    operator: "equal",
                    value: "EXPRESS_SCRIPTS",
                },
                {
                    field: "subgroup_number",
                    operator: "in",
                    value: ["CSRAINC", "BLTA", "RX4CCPS"],
                }, {
                    combinator: "or",
                    rules: [
                        {
                            field: "subgroup_number1",
                            operator: "contains",
                            value: "EBAM",
                        },
                        {
                            field: "subgroup_number1",
                            operator: "contains",
                            value: "EBA&M",
                        },
                    ]
                }
            ],
        }
    };
    
    rowIdParam = new URLSearchParams(this.props.location.search);
    rowId = this.rowIdParam.get('row');    
    ruleId = this.rowIdParam.get('ruleId'); 
    
    render() {
        const selectedRule = rules.find(rule => ''+rule.id === this.rowId).rules;
        let formattedQuery = QueryBuilder.formatQuery(selectedRule);
        let sqlQuery = QueryBuilder.sqlQuery(selectedRule);
        const stdSql = 'insert into clone_lead select *, "'+this.ruleId+'" from cob_lead_staging where '
        
        return (
            <div className="App App-canvas">
                <QueryBuilder
                    filters={this.filters}
                    query={selectedRule}
                    maxLevels={4}
                    onChange={(selectedRule, valid) => {
                        this.setState(selectedRule);
                    }}
                />
                <div style={{ display: 'inline-block', width: '100%', overflow: 'hidden', paddingLeft: 10 }}>
                <div align="left" style={{ float: 'left' }}>
                    <pre>
                        {JSON.stringify(formattedQuery, null, 2)}     
                    </pre>
                </div>
                <div align="left"> 
                    {stdSql+sqlQuery}
                </div>
                </div>

            </div>
        );
    }
}

