import React, { Component } from "react";
import { Router, Switch, Route } from "react-router-dom";

import ManageRule from "./manage-rule/ManageRule";
import RuleList from "./rule-list/RuleList";
import history from './history';

export default class Routes extends Component {
    render() {
        return (
            <Router history={history}>
                <Switch>
                    <Route path="/" exact component={RuleList} />
                    <Route path="/LoadRule" component={ManageRule} />
                </Switch>
            </Router>
        )
    }
}