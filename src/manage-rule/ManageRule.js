import React, { Component } from 'react';
import QueryBuilder from "../rools/QueryBuilder";
import UpdateQueryBuilder from "../rools/UpdateQueryBuilder";
import ruleoptions from '../data/filters.json';
import rules from '../data/rules.json';
import Button from '@material-ui/core/Button';
import history from '../history';
import updateoptions from '../data/updatefilters.json'
import Paper from '@material-ui/core/Paper';
import Tabs from '@material-ui/core/Tabs';
import Tab from '@material-ui/core/Tab';
import './ManageRule.css';

export default class ManageRule extends Component {

    filters = ruleoptions;
    state = {
        defaultRule: {
        ruleid: "RULE_NEW",
        description: "Rule New",
        status: "Active",
        version: "1.0",
        created_datetime: "",
        updated_datetime: "",
        selectRules: {
            combinator: "and",
            rules: [
                {
                    field: null,
                    operator: null,
                    value: null,
                },
            ],
        },
        updateRules: {
            combinator: "set",
            sets: [
                {
                    field: null,
                    operator: null,
                    value: null,
                },
            ],
        },
        updateConditions: {
            combinator: "and",
            rules: [
                {
                    field: null,
                    operator: null,
                    value: null,
                },
            ],
        }
    },
        activeTabIndex: 0,
        ruleQuery: {},
    };

    rowIdParam = new URLSearchParams(this.props.location.search);
    rowId = this.rowIdParam.get('row');
    ruleId = this.rowIdParam.get('ruleId');

    
    

    render() {
        let defaultRule = this.state.defaultRule;        
        if(rules.find(rule => '' + rule.id === this.rowId)){
            defaultRule = rules.find(rule => '' + rule.id === this.rowId);
        }
        let ruleQuery = this.state.ruleQuery;
        
        const activeTabIndex = this.state.activeTabIndex;

        

        return (
            <div className="App App-canvas">
                <div align="left" style={{ width: "100%" }}>
                    <h3>Carrier Edit Rule - {this.ruleId}</h3>
                    
                </div>
                <Paper square>
                    <Tabs
                        value={activeTabIndex}
                        indicatorColor="primary"
                        textColor="primary"
                        onChange={(event, activeTabIndex) => {
                            this.setState({activeTabIndex: activeTabIndex});
                            fetch('http://localhost:3001/api', {
                                method: 'POST',
                                headers: {'Content-Type':'application/json'},
                                body: JSON.stringify(defaultRule)
                    
                            })
                            .then(res => res.json())
                            .then(
                                (result) => {
                                    this.setState((prevState) => ({ruleQuery: result.query}));
                                })
                          }}                          
                    >
                        <Tab label="Rule Config" />
                        <Tab label="JSON Output" />
                        <Tab label="SQL Output" />
                    </Tabs>
                    
                </Paper>
                <TabPanel activeTabIndex={activeTabIndex} index={0}>
                        
                       
                
                <div align="left" class="header"><b>When:</b></div>
                <QueryBuilder
                    filters={this.filters}
                    query={defaultRule.selectRules}
                    maxLevels={4}
                    onChange={(defaultRule, valid) => {
                        this.setState(defaultRule.selectRules);
                    }}
                />
                <div align="left"><b>Clone the Lead and Change:</b></div>
                <UpdateQueryBuilder
                    filters={updateoptions}
                    query={defaultRule.updateRules}
                    maxLevels={1}
                    onChange={(defaultRule, valid) => {
                        this.setState(defaultRule.updateRules);
                    }}
                />
                <QueryBuilder
                    filters={this.filters}
                    query={defaultRule.updateConditions}
                    maxLevels={4}
                    onChange={(defaultRule, valid) => {
                        this.setState(defaultRule.updateConditions);
                    }}
                />
                
                </TabPanel>
                    <TabPanel activeTabIndex={activeTabIndex} index={1}>
                        
                <div style={{ display: 'inline-block', width: '100%', overflow: 'hidden', paddingLeft: 10, paddingTop: 20 }}>

                    <div align="left" style={{ float: 'left', paddingRight: 50 }}>
                        <pre>
                            {JSON.stringify(QueryBuilder.newFormatQuery(defaultRule), null, 2)}
                        </pre>
                        
                    </div>                    
                </div>
                </TabPanel>
                    <TabPanel activeTabIndex={activeTabIndex} index={2}>
                    <div style={{ display: 'inline-block', width: '100%', overflow: 'hidden', paddingLeft: 10, paddingTop: 20 }}>


<div align="left" style={{ paddingLeft: 30, paddingRight: 50 }}>
    <span style={{ fontWeight: 500 }}>
        <span style={{ color: "#3f51b5" }}>insert into</span> <span style={{ color: "#f50057" }}> clone_lead </span><br />
        <span style={{ color: "#3f51b5" }}>select </span> *, &apos;{this.ruleId}&apos; <span style={{ color: "#3f51b5" }}> from </span> <span style={{ color: "#f50057" }}> cob_lead_staging </span> <br />
        <span style={{ color: "#3f51b5" }}>where </span> {ruleQuery.selectRules + ';'} <br/>
        
        <span style={{ color: "#3f51b5" }}>update </span> <span style={{ color: "#f50057" }}> clone_lead </span><br />
        <span style={{ color: "#3f51b5" }}>set </span> {ruleQuery.updateRules } <br/>
        <span style={{ color: "#3f51b5" }}>where </span> {ruleQuery.updateConditions + ';'}
        </span>
        
</div>
</div>

                    </TabPanel>
                <div align="right" style={{ position: 'sticky', bottom: 0, zIndex: 1, padding: 10 }}>
                    <Button
                        variant="contained"
                        color="secondary"
                        onClick={() => history.push('/')}
                    >
                        Close
                    </Button>
                </div>
            </div>
        );
    }
}

function TabPanel(props)
        {
            const {children, activeTabIndex, index} = props;
            return(
                <div>
                    
                {
                    activeTabIndex === index && (
                        <div>{children}</div>
                    )
                }
                </div>
            )
        }
        