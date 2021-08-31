import React, { Component } from 'react';
import { DataGrid } from '@material-ui/data-grid';
import Icon from '@material-ui/core/Icon';
import IconButton from '@material-ui/core/IconButton';
import './Rulelist.css'
import { Switch, Route, Link } from "react-router-dom";
import NewRule from './NewRule';
import history from './history';

export default class RuleList extends Component{
    rows = [{ id: 1, ruleid: 'RULE_1', description: '1', status: 'Active'},
    { id: 2, ruleid: 'RULE_2', description: '1', status: 'Active'},
    { id: 3, ruleid: 'RULE_120', description: '1', status: 'Active'}];
    
    state={rows: this.rows};
    newRowId = this.state.rows.length + 1;
    newRow = { id: this.newRowId, ruleid: 'RULE_'+this.newRowId, description: '1', status: 'Active'};
    columns = [
    
    { field: 'ruleid', 
        headerName: 'Rule ID', 
        flex: 0.5,
        minWidth: 150,
        editable: true,
    },
    {
        field: 'description',
        headerName: 'Description',
        flex: 2,
        minWidth: 350,    
        editable: true,
    },
    {
        field: 'status',
        headerName: 'Status',
        flex: 0.5,
        minWidth: 150,
    },
    {
        field: '',
        headerName: 'Add/Delete',
        sortable: false,
        disableColumnMenu: true,
        showColumnRightBorder: false,
        disableClickEventBubbling: true,
        renderHeader: (params) => {     
            const onClick = () => {
            //const api: GridApi = params.api; 
            this.setState({rows: [...this.state.rows, this.newRow], selected: [], nbRender: 1});
            };
            return <IconButton onClick={onClick}><Icon color="primary">add_circle_outline</Icon></IconButton>;
        },
        renderCell: (params) => {     
            const onClick = () => {
            //const api: GridApi = params.api; 
            history.push('/LoadRule');
            };
            return <IconButton onClick={onClick}><Icon color="secondary">edit</Icon></IconButton>;
        }
    },
    
    ];

  render (){
    return (
    <div style={{ overflowX: 'hidden'}}>
    <div style={{ display: 'inline-block', width: '100%', overflow: 'hidden', paddingLeft: 10 }}>
    <div style={{ float: 'left' }}>
        <h2>Rule List</h2>
    </div>
</div>
<div style={{ height: 400, padding: 10 }}>
       
  <DataGrid
    rows={this.state.rows}
    columns={this.columns}
    pageSize={5}
    checkboxSelection
    disableSelectionOnClick
    disableExtendRowFullWidth = {false}
  />
</div>
</div>
    );
  }
}

//export default DataTable;