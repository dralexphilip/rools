import React, { Component, useEffect, useState } from 'react';
import Icon from '@material-ui/core/Icon';
import IconButton from '@material-ui/core/IconButton';
import './Rulelist.css';
import history from '../history';
import Alert from '@material-ui/lab/Alert';
import Snackbar from '@material-ui/core/Snackbar';
import Button from '@mui/material/Button';
import {
    DataGrid,
    GridToolbar,
    GridToolbarContainer,
    GridToolbarColumnsButton,
    GridToolbarFilterButton,
    GridToolbarExport,
    GridToolbarDensitySelector,
  } from '@mui/x-data-grid';

    

export default function RuleList() {
    const [config, setConfig] = useState({})
    const [rows, setRows] = useState([])
    const [successAlert, setSuccessAlert] = useState(false)
    const [selectedRule, setSelectedRule] = useState('')
    const columns = [
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
            field: 'insertSql',
            headerName: 'Insert SQL',
            flex: 0.30,
            editable: true,
        },
        {
            field: 'updateSql',
            headerName: 'Update SQL',
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
                    
                    console.log(config.token)
                    console.log(config.identity)
                history.push('/LoadRule?row='+params.row.id+'&ruleId='+params.row.ruleId, params.row);
                };
                return <IconButton onClick={onClick}><Icon color="secondary">pageview</Icon></IconButton>;
            }
        },
        {
            field: 'publish',
            headerName: 'Publish',
            flex: 0.1,
            sortable: true,
            disableColumnMenu: true,
            showColumnRightBorder: false,
            disableClickEventBubbling: true,            
            renderCell: (params) => {   
                    if(params.row.publish==='S'){ 
                    const onClick = () => {
                        fetch(config.url, {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                                'authorization': `Bearer ` + config.token,
                                'identity': config.identity
                            },
                            body: JSON.stringify(params.row)
                            })
                            .then(res => res.json())
                            .then(
                                (result) => {
                                    console.log(result)
                                    setSuccessAlert(true)
                                    setSelectedRule(params.row.ruleId)
                                })
                    };
                    return <IconButton onClick={onClick}><Icon color="secondary">publish</Icon></IconButton>;
                }
                else{
                    return <IconButton disabled ><Icon color="default">publish</Icon></IconButton>;
                }
            }
        },
    ];

    const fetchConfigData = async () => {
        try {
            const response1 = await fetch('http://localhost:3001/config');
            const json1 = await response1.json();
            setConfig(json1)
            
        } catch (error) {
            console.log("error", error);
        }
    };


    useEffect(() => {
        
        const url = "http://localhost:3001/sqltojs";
        const fetchData = async () => {
            try {
                const response = await fetch(url);
                const json = await response.json();
                //console.log(json);
                json.query.sort((a, b) => a.ruleId > b.ruleId ? 1 : -1);
                setRows(json.query);
            } catch (error) {
                console.log("error", error);
            }
        };
        fetchData();

        fetchConfigData();
        

      }, []);

    const sleep = async (milliseconds) => {
        await new Promise(resolve => {
            return setTimeout(resolve, milliseconds)
        });
    };

    const publishClick = async () => {        
        for (let i = 0; i < rows.length; i++) {
            await sleep(rows[i].id.substring(rows[i].id.length - 1) === '0'?config.apiInterval:50);          
            if (rows[i].publish === 'S') {                  
                fetch(config.url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'authorization': `Bearer ` + config.token,
                    'identity': config.identity
                },
                body: JSON.stringify(rows[i])
                })
                .then(res => res.json())
                .then(
                    (result) => {
                        console.log(result)
                        setSuccessAlert(true)
                        setSelectedRule(rows[i].ruleId)
                    })                                  
            }
        }

    };

function CustomToolbar() {
    return (
      <GridToolbarContainer>
        <GridToolbarColumnsButton />
        <GridToolbarFilterButton />
        <GridToolbarDensitySelector />
        <GridToolbarExport />
        <Button variant="text" size="small" startIcon={<Icon >publish</Icon>} onClick={publishClick} >Publish All</Button>
      </GridToolbarContainer>
    );
  }

   
    return (
        <div style={{ overflowX: 'hidden' }}>
            <div align="left" style={{ width: "100%", paddingBottom: 20 }}>
                <h3>Carrier Edit Rules</h3>
                <hr></hr>
            </div>
            <div style={{ height: 800, padding: 10 }}>

                <DataGrid
                    rows={rows}
                    sx={{
                        '@media print': {
                          '.MuiDataGrid-main': {
                            width: 'fit-content',
                            fontSize: '10px',
                            height: 'fit-content',
                            overflow: 'visible',
                          },
                          '.MuiDataGrid-cellContent':{
                            width: 'fit-content',
                            fontSize: '10px',
                            height: 'fit-content',
                            overflow: 'visible',
                          },
                          marginBottom: 100,
                        },
                      }}
                    columns={columns}
                    pageSize={10}
                    checkboxSelection
                    disableSelectionOnClick
                    rowsPerPageOptions={[5, 10, 20]}
                    components={{
                        Toolbar: CustomToolbar,
                        GridToolbar: {
                            printOptions:{
                              pageStyle: '.MuiDataGrid-root .MuiDataGrid-main { color: rgba(0, 0, 0, 0.87); }',
                            }
                          },
                      }}
                    initialState={{
                    columns: {
                        columnVisibilityModel: {
                        // Hide columns status and traderName, the other columns will remain visible
                        'insertSql': false,
                        'updateSql': false,
                        },
                    },
                    }}
                />
                <Snackbar 
                    open={successAlert} 
                    anchorOrigin={{ 'vertical': 'top', 'horizontal': 'right' }}
                    autoHideDuration={6000} 
                    onClose={() => {
                            setSuccessAlert(false);
                            }}>
                    <Alert 
                        onClose={() => {
                            setSuccessAlert(false);
                            }} 
                        severity="success" 
                        sx={{ width: '100%' }}>
                    <b>RULE_{ selectedRule }</b> published successfully to TPL Match Next!
                    </Alert>
                </Snackbar>
            </div>
        </div>
    );

}

//export default DataTable;