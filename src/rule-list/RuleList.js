import React, { Component, useEffect, useState } from 'react';
import { DataGrid } from '@material-ui/data-grid';
import Icon from '@material-ui/core/Icon';
import IconButton from '@material-ui/core/IconButton';
import './Rulelist.css';
import history from '../history';

export default function RuleList() {
    const [rows, setRows] = useState([])

    const [columns, setColumns] = useState([
        {
            field: 'id',
            headerName: 'ID',
            flex: 0.2,
            minWidth: 100,
            editable: false,
        },

        {
            field: 'ruleId',
            headerName: 'Rule ID',
            flex: 0.25,
            editable: false,
        },
        {
            field: 'description',
            headerName: 'Description',
            flex: 0.30,
            editable: true,
        },
        {
            field: 'status',
            headerName: 'Status',
            flex: 0.3,
        },
        {
            field: 'version',
            headerName: 'Version',
            flex: 0.2,
        },
        {
            field: 'review',
            headerName: 'Review',
            flex: 0.1,
            sortable: false,
            disableColumnMenu: true,
            showColumnRightBorder: false,
            disableClickEventBubbling: true,
            renderCell: (params) => {     
                const onClick = () => {
                history.push('/LoadRule?row='+params.row.id+'&ruleId='+params.row.ruleId, params.row);
                };
                return <IconButton onClick={onClick}><Icon color="secondary">pageview</Icon></IconButton>;
            }
        },
        {
            field: 'publish',
            headerName: 'Publish',
            flex: 0.1,
            sortable: false,
            disableColumnMenu: true,
            showColumnRightBorder: false,
            disableClickEventBubbling: true,            
            renderCell: (params) => {     
                const onClick = () => {
                history.push('/LoadRule?row='+params.row.id+'&ruleId='+params.row.ruleId, params.row);
                };
                return <IconButton onClick={onClick}><Icon color="secondary">publish</Icon></IconButton>;
            }
        },
    ]);

    useEffect(() => {
        const url = "http://localhost:3001/sqltojs";

        const fetchData = async () => {
            try {
                const response = await fetch(url);
                const json = await response.json();
                console.log(json);
                setRows(json.query);
            } catch (error) {
                console.log("error", error);
            }
        };

        fetchData();
      }, []);

    return (
        <div style={{ overflowX: 'hidden' }}>
            <div align="left" style={{ width: "100%", paddingBottom: 20 }}>
                <h3>Carrier Edit Rules</h3>
                <hr></hr>
            </div>
            <div style={{ height: 800, padding: 10 }}>

                <DataGrid
                    rows={rows}
                    columns={columns}
                    pageSize={10}
                    checkboxSelection
                    disableSelectionOnClick
                    rowsPerPageOptions={[5, 10, 20]}
                />
            </div>
        </div>
    );

}

//export default DataTable;