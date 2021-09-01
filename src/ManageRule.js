import React, { Component } from 'react';
import QueryBuilder from "./QueryBuilder";
import ruleoptions from './filters.json';
import rules from './rules.json';
import Button from '@material-ui/core/Button';
import history from './history';

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
                <div align="left" style={{ paddingLeft: 500, paddingTop: 20, paddingRight: 50 }}> 
                <span style={{fontWeight: 500}}>
                    <span style={{color: "#3f51b5"}}>insert into</span> <span style={{color: "#f50057"}}> clone_lead </span><br/>
                    <span style={{color: "#3f51b5"}}>select </span> *, {this.ruleId} <span style={{color: "#3f51b5"}}> from </span> <span style={{color: "#f50057"}}> cob_lead_staging </span> <br/>
                    <span style={{color: "#3f51b5"}}>where </span> {sqlQuery+';'}</span>
                </div>
                </div>
                <div align="right" style={{ position: 'sticky', bottom: 0, zIndex: 1, padding: 10 }}>
                <Button
                    variant="contained"
                    color="secondary"
                    onClick={()=> history.push('/')}
                >
                    Close
                </Button>
                </div>
            </div>
        );
    }
}

