import React, { Component } from 'react';
import { DataGrid } from '@material-ui/data-grid';
import Icon from '@material-ui/core/Icon';
import IconButton from '@material-ui/core/IconButton';
import './Rulelist.css';
import history from './history';
import rules from './rules.json'

export default class RuleList extends Component{
    rows = rules;
    
    state={rows: this.rows, sortModel: [{field: 'id', sort: 'desc',}]};
    newRowId = this.state.rows.length + 1;
    newRow = { id: this.newRowId, ruleid: 'RULE_'+this.newRowId, description: '1', status: 'Active'};
    columns = [
    { field: 'id', 
        headerName: 'ID', 
        flex: 0.5,
        minWidth: 150,
        editable: false,
    },
    
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
            this.setState(prevState => ({rows: [...prevState.rows, { id: this.state.rows.length + 1, ruleid: 'RULE_'+(this.state.rows.length + 1), description: '', status: 'Active'}]}));
            };
            return <IconButton onClick={onClick}><Icon color="primary">add_circle_outline</Icon></IconButton>;
        },
        renderCell: (params) => {     
            const onClick = () => {
            //const api: GridApi = params.api; 
            history.push('/LoadRule?row='+params.row.id+'&ruleId='+params.row.ruleid);
            console.log(params.row.id)
            };
            return <IconButton onClick={onClick}><Icon color="secondary">edit</Icon></IconButton>;
        }
    },
    
    ];

    

  render (){
    return (
    <div style={{ overflowX: 'hidden'}}>
    <div align="left" style={{ width: "100%", paddingBottom: 20 }}>
        <h3>Carrier Edit Rules</h3>
        <hr></hr>
    </div>
<div style={{ height: 400, padding: 10 }}>
       
  <DataGrid
    rows={this.state.rows}
    columns={this.columns}
    pageSize={5}
    checkboxSelection
    disableSelectionOnClick
    sortModel={this.state.sortModel}
  />
</div>
</div>
    );
  }
}

//export default DataTable;