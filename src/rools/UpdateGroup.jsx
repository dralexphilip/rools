import { Button, Grid, IconButton, Typography } from "@material-ui/core";
import { makeStyles } from "@material-ui/core/styles";
import { AddCircleOutline as AddIcon, RemoveCircleOutline as RemoveIcon } from "@material-ui/icons";
import { ToggleButton, ToggleButtonGroup } from "@material-ui/lab";
import PropTypes from "prop-types";
import React from "react";
import { Draggable, Container as DraggableContainer } from "react-smooth-dnd";

import Context from "./context";
import Field from "./Field";
import Operator from "./Operator";
import Value from "./Value";

const removeIconStyles = (t) => ({
    removeButton: {
        marginRight: t.spacing(-1),
        marginTop: t.spacing(0.75),
    },
    removeIcon: {
        fill: "#f50057",
    },
});

const useSetStyles = makeStyles((t) => {
    return {
        ...removeIconStyles(t),
        container: {
            "& > div": {
                marginBottom: t.spacing(0.5),
                marginTop: t.spacing(0.5),
            },
            "cursor": "move",
        },
        valueGridItem: {
            flex: "auto",
        },
    };
});

const Set = (props) => {
    const classes = useSetStyles();
    const context = React.useContext(Context);

    const { id, level, position, set, combi } = props;
    const { combinator, field, operator, sets, value, tfield, toperator, tvalue } = set;

    const { dispatch } = context;

    const testId = `${level}-${position}`;
    const whenCombi = [{label: "WHEN", value: "when"}];

    return combinator ? (
        <>
        <SetGroup combinator={combinator} id={id} level={level + 1} sets={sets} />
        </>
    ) : (
        <Grid container className={classes.container} data-testid={`set-${testId}`} spacing={2}>
            <Grid item>
                <IconButton
                    className={classes.removeButton}
                    data-testid={`set-${testId}-remove`}
                    size="small"
                    onClick={() => {
                        dispatch({ type: "remove-node", id });
                    }}
                >
                    <RemoveIcon className={classes.removeIcon} />
                </IconButton>
            </Grid>
            {combi === "case" ? (
            <>            
            <Grid item>
                <ToggleButtonGroup
                            exclusive
                            size="small"
                            value={"when"}
                            onChange={(event, value) => {
                                if (value) {
                                    dispatch({ type: "set-combinator", id, value });
                                }
                            }}
                        >
                            {whenCombi.map((item) => (
                                <ToggleButton
                                    key={item.value}
                                    data-testid={`${testId}-combinator-${item.value}`}
                                    className={classes.combinator}
                                    value={item.value}
                                >
                                    <Typography variant="body2">{item.label}</Typography>
                                </ToggleButton>
                            ))}
                        </ToggleButtonGroup>                    
            </Grid>
            </>
                ): ""}
            <Grid item>
                <Field field={field} id={id} testId={testId} placeholder="Field"/>
            </Grid>
            <Grid item>
                <Operator field={field} id={id} operator={operator} testId={testId} />
            </Grid>
            <Grid item className={classes.valueGridItem}>
                <Value field={field} id={id} operator={operator} testId={testId} value={Array.isArray(value)? value[0]: value} vtype="field"/>
            </Grid>
            
            {combi === "case" ? (
            <>
           
            
            <Grid item>
                <ToggleButtonGroup
                            exclusive
                            size="small"
                            value={"then"}
                            onChange={(event, value) => {
                                if (value) {
                                    dispatch({ type: "set-combinator", id, value });
                                }
                            }}
                        >
                            {[{label: "THEN", value: "then"}].map((item) => (
                                <ToggleButton
                                    key={item.value}
                                    data-testid={`${testId}-combinator-${item.value}`}
                                    className={classes.combinator}
                                    value={item.value}
                                >
                                    <Typography variant="body2">{item.label}</Typography>
                                </ToggleButton>
                            ))}
                        </ToggleButtonGroup>                    
            </Grid>
            <Grid item className={classes.valueGridItem}>
                <Value field={field} id={id} operator={toperator} testId={testId} value={value[1]} vtype="case"/>
            </Grid>
            </>
            ): ""}
            
        </Grid>
    );
};

Set.propTypes = {
    id: PropTypes.number.isRequired,
    level: PropTypes.number.isRequired,
    position: PropTypes.number.isRequired,
    set: PropTypes.object.isRequired,
};

//*******************************/


//*******************************************/




const useSetGroupStyles = makeStyles((t) => ({
    actionButton: {
        "& svg": {
            marginRight: t.spacing(0.5),
            marginTop: t.spacing(0.25),
        },
        "textTransform": "none",
    },
    combinator: {
        height: 36,
        padding: t.spacing(0, 1.5),
    },
    group: {
        borderLeft: (props) => (props.level > 0 ? `2px solid ${t.palette.divider}` : "none"),
        paddingLeft: t.spacing(1.5),
        marginBottom: t.spacing(0.5),
        marginTop: (props) => (props.level > 0 ? t.spacing(0.5) : "none"),
    },
    ...removeIconStyles(t),
}));

const SetGroup = (props) => {
    const classes = useSetGroupStyles(props);
    const context = React.useContext(Context);

    const { combinator, combinators, id, level, sets, cfield } = props;
    const testId = `group-${level}`;

    const { dispatch, maxLevels } = context;

    return level <= maxLevels ? (
        <Grid container className={classes.group} data-testid={testId} direction="column" spacing={1}>
            <Grid item>            
                <Grid container spacing={2}>
                    <Grid item>
                        <IconButton
                            className={classes.removeButton}
                            data-testid={`${testId}-remove`}
                            disabled={level === 0}
                            size="small"
                            onClick={() => {
                                dispatch({ type: "remove-node", id });
                            }}
                        >
                            <RemoveIcon className={level > 0 ? classes.removeIcon : null} />
                        </IconButton>
                    </Grid>
                    {combinator === "case" ? (
                    <Grid item>
                        <Field field={sets[0].field} id={id} testId={testId} placeholder="Case" />
                    </Grid>
                    ): ""}
                    <Grid item>
                        <Button
                            className={classes.actionButton}
                            color="primary"
                            data-testid={`${testId}-add-set`}
                            onClick={() => {
                                dispatch({ type: "add-set", id });
                            }}
                        >
                            <AddIcon />
                            Field
                        </Button>
                    </Grid>
                    {level < maxLevels && (
                        <Grid item>
                            <Button
                                className={classes.actionButton}
                                color="primary"
                                data-testid={`${testId}-add-group`}
                                onClick={() => {
                                    dispatch({ type: "add-group", id });
                                }}
                            >
                                <AddIcon />
                                Case
                            </Button>
                        </Grid>
                    )}
                </Grid>
            </Grid>
            {sets?.length > 0 && (
                <Grid item>
                    <DraggableContainer
                        onDrop={({ addedIndex, removedIndex }) => {
                            dispatch({ type: "move-set", addedIndex, id, removedIndex });
                        }}
                    >
                        {sets.map((set, position) => (
                            <Draggable key={set.id}>
                                <Set id={set.id} level={level} position={position} set={set} combi={combinator}/>
                            </Draggable>
                        ))}
                    </DraggableContainer>
                </Grid>
            )}
        </Grid>
    ) : (
        <span />
    );
};

SetGroup.defaultProps = {
    combinator: "case",
    combinators: [
        { label: "SET", value: "set" },
        { label: "CASE", value: "case" },
    ],
    sets: [],
};

SetGroup.propTypes = {
    combinator: PropTypes.string,
    combinators: PropTypes.array,
    id: PropTypes.number.isRequired,
    level: PropTypes.number.isRequired,
    sets: PropTypes.array,
    cfield: PropTypes.string,
};

export default SetGroup;
