const operators = [
    {
        label: "equal to",
        value: "equal",
        types: ["date", "integer", "number", "radio", "select", "switch", "text"],
        symbol: "=",
    },
    {
        label: "not equal to",
        value: "not_equal",
        types: ["date", "integer", "number", "radio", "select", "switch", "text"],
        symbol: "!=",
    },
    {
        label: "contains",
        value: "contains",
        types: ["text"],
        symbol: "like",
    },
    {
        label: "does not contain",
        value: "not_contains",
        types: ["text"],
        symbol: "not like",
    },
    {
        label: "less than",
        value: "less",
        types: ["number", "integer"],
        symbol: "<",
    },
    {
        label: "greater than",
        value: "greater",
        types: ["number", "integer"],
        symbol: ">",
    },
    {
        label: "less or equal to",
        value: "less_equal",
        types: ["number", "integer"],
        symbol: "<=",
    },
    {
        label: "greater or equal to",
        value: "greater_equal",
        types: ["number", "integer"],
        symbol: ">=",
    },
    {
        label: "before than",
        value: "before",
        types: ["date"],
        symbol: "<",
    },
    {
        label: "after than",
        value: "after",
        types: ["date"],
        symbol: ">",
    },
    {
        label: "before or equal to",
        value: "before_equal",
        types: ["date"],
        symbol: "<=",
    },
    {
        label: "after or equal to",
        value: "after_equal",
        types: ["date"],
        symbol: ">=",
    },
    {
        label: "in",
        value: "in",
        types: ["multiselect"],
        symbol: "in",
    },
    {
        label: "not in",
        value: "not_in",
        types: ["multiselect"],
        symbol: "not in",
    },
    {
        label: "is null",
        value: "null",
        types: ["date", "integer", "number", "multiselect", "radio", "select", "switch", "text"],
        symbol: "is null",
    },
    {
        label: "is not null",
        value: "not_null",
        types: ["date", "integer", "number", "multiselect", "radio", "select", "switch", "text"],
        symbol: "is not null",
    },
];

export default operators;
