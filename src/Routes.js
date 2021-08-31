import React, { Component } from "react";
import { Router, Switch, Route } from "react-router-dom";

import LoadRule from "./NewRule";
import RuleList from "./RuleList";
import history from './history';

export default class Routes extends Component {
    render() {
        return (
            <Router history={history}>
                <Switch>
                    <Route path="/" exact component={RuleList} />
                    <Route path="/LoadRule" component={LoadRule} />
                </Switch>
            </Router>
        )
    }
}