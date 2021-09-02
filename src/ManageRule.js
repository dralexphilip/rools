import React, { Component } from 'react';
import QueryBuilder from "./QueryBuilder";
import ruleoptions from './filters.json';
import rules from './rules.json';
import Button from '@material-ui/core/Button';
import history from './history';

export default class ManageRule extends Component {

    filters = ruleoptions;
    state = {
        query: {
            combinator: "and",
            rules: [
                {
                    field: null,
                    operator: null,
                    value: null,
                },
            ],
        }
    };

    rowIdParam = new URLSearchParams(this.props.location.search);
    rowId = this.rowIdParam.get('row');
    ruleId = this.rowIdParam.get('ruleId');

    render() {
        let selectedRule = this.state.query;//rules.find(rule => '' + rule.id === this.rowId).rules;
        if(rules.find(rule => '' + rule.id === this.rowId))
            selectedRule = rules.find(rule => '' + rule.id === this.rowId).rules;
        let formattedQuery = QueryBuilder.formatQuery(selectedRule);
        let sqlQuery = QueryBuilder.sqlQuery(selectedRule);

        return (
            <div className="App App-canvas">
                <div align="left" style={{ width: "100%", paddingBottom: 20 }}>
                    <h3>Carrier Edit Rule - Detection and Insertion - {this.ruleId}</h3>
                    <hr></hr>
                </div>

                <QueryBuilder
                    filters={this.filters}
                    query={selectedRule}
                    maxLevels={4}
                    onChange={(selectedRule, valid) => {
                        this.setState(selectedRule);
                    }}
                />
                <div style={{ display: 'inline-block', width: '100%', overflow: 'hidden', paddingLeft: 10, paddingTop: 20 }}>

                    <div align="left" style={{ float: 'left', paddingRight: 50 }}>
                        <b>JSON Rules</b>
                        <pre>
                            {JSON.stringify(formattedQuery, null, 2)}
                        </pre>
                    </div>
                    <div align="left" style={{ paddingLeft: 300, paddingRight: 50 }}>
                        <b>Generated SQL</b><br /><br />
                        <span style={{ fontWeight: 500 }}>
                            <span style={{ color: "#3f51b5" }}>insert into</span> <span style={{ color: "#f50057" }}> clone_lead </span><br />
                            <span style={{ color: "#3f51b5" }}>select </span> *, &apos;{this.ruleId}&apos; <span style={{ color: "#3f51b5" }}> from </span> <span style={{ color: "#f50057" }}> cob_lead_staging </span> <br />
                            <span style={{ color: "#3f51b5" }}>where </span> {sqlQuery + ';'}</span>
                    </div>
                </div>
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

