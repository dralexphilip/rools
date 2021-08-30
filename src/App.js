import logo from './logo.svg';
import './App.css';
import QueryBuilder from "./QueryBuilder";
import React, { useState } from "react";

const filters = [
  {
      label: "COB Lead Staging",
      options: [
          {
              label: "Carrier Name",
              value: "carrier_name",
              type: "select",
              options: [
                  {
                      label: 'Express Scripts',
                      value: 'EXPRESS_SCRIPTS'
                  },
                  {
                      label: 'Regular Scripts',
                      value: 'REGULAR_SCRIPTS'
                  },
                  {
                      label: 'Catamaran',
                      value: 'CATAMARAN'
                  }
              ],
          },
          {
              label: "Group Name",
              value: "group_name",
              type: "multiselect",
              options: [
                  {
                      label: 'CENTRAL STATES HEALTH FUND',
                      value: 'CENTRAL STATES HEALTH FUND'
                  },
                  {
                      label: 'CENTRAL STATES HLTH FUND',
                      value: 'CENTRAL STATES HLTH FUND'
                  },
              ],
          },
          {
              label: "Group Number",
              value: "group_number",
              type: "multiselect",
              options: [
                  {
                      label: 'PSI2658',
                      value: 'PSI2658'
                  },
                  {
                      label: 'PSI2687',
                      value: 'PSI2687'
                  },
                  {
                      label: '0272',
                      value: '0272'
                  },
                  {
                      label: '0273',
                      value: '0273'
                  },
              ],
          },
          {
              label: "Sub-group Number",
              value: "subgroup_number",
              type: "multiselect",
              options: [
                  {
                      label: 'CSRAINC',
                      value: 'CSRAINC'
                  },
                  {
                      label: 'RX4CCPS',
                      value: 'RX4CCPS'
                  },
                  {
                      label: 'SODEXO',
                      value: 'SODEXO'
                  },
                  {
                      label: 'BLTA',
                      value: 'BLTA'
                  }
              ],
          },
          {
              label: "Medical Name",
              value: "medical_name",
              type: "multiselect",
              options: [
                  {
                      label: 'RWTEBAMPB',
                      value: 'RWTEBAMPB'
                  },
                  {
                      label: 'RWTEBAM',
                      value: 'RWTEBAM'
                  }
              ],
          },
      ],
  },
  {
      label: "COB Lead Staging - All Text",
      options: [
          {
              label: "Carrier Name",
              value: "carrier_name1",
              type: "text",
          },
          {
              label: "Group Name",
              value: "group_name1",
              type: "text",
          },
          {
              label: "Group Number",
              value: "group_number1",
              type: "text",
          },
          {
              label: "Sub-group Number",
              value: "subgroup_number1",
              type: "text",
          },
          {
              label: "Medical Name",
              value: "medical_name1",
              type: "text",
          },
      ],
  },
];

function App() {
  const [query, setQuery] = useState({
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
});
const formattedQuery = QueryBuilder.formatQuery(query);
console.log(formattedQuery);
  return (
    <div className="App App-canvas">
        <QueryBuilder
                filters={filters}
                query={query}
                maxLevels={4}
                onChange={(query, valid) => {
                    setQuery(query);
                }}
            />
        <div align="left">
            <pre>
            {JSON.stringify(formattedQuery, null, 2)}
       
        </pre>
        
        </div>
            
    </div>
  );
  
}

export default App;
