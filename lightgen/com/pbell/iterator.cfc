<cfcomponent output="false"><cfscript>

// ***************** CONSTRUCTOR *****************

function init() {
	variables.instance = structNew();
	variables.instance[ 1 ] = structNew();
	variables.metadata = structNew();
	return THIS;
}


// ***************** PUBLIC METHODS *****************

function asQuery() {
	return variables.metadata.Query;
}

function asStruct() {
	return variables.instance;
}

function first() {
	variables.metadata.IteratorCount = 1;
	return THIS;
}

function getFirst() {
	return variables.metadata.BusinessObject.load( variables.instance[ 1 ] );
}

function getNext() {
	return variables.metadata.BusinessObject.load( variables.instance[ variables.metadata.IteratorCount ] );
}

function hasMore() {
	if ( variables.metadata.IteratorCount LT variables.metadata.NumberofRecords ) {
		variables.metadata.IteratorCount++
		return true;
	}
	return false;
}

function load( BusinessObject , Query ) {
	variables.metadata.BusinessObject = arguments.BusinessObject;
	loadQuery( Query );
	return THIS;
}

function metadata() {
	return variables.metadata;
}

function recordCount() {
	return variables.metadata.NumberofRecords;
}

function reset() {
	variables.metadata.IteratorCount = 0;
	return THIS;
}


// ***************** PRIVATE METHODS *****************

function loadQuery( Query ) {
	var cols = ListToArray( Query.columnlist );
	var row = 1;
	var col = 1;
	var thisRow = "";
	for( row = 1; row LTE Query.recordcount; row++ ) {
		thisRow = structNew();
		for( col = 1; col LTE arraylen( cols ); col++ ) {
			thisRow[ cols[ col ] ] = Query[ cols[ col ] ][ row ];
		} 
		variables.instance[ row ] = Duplicate( thisRow );
	} 
	variables.metadata.NumberofRecords = Query.recordcount;
	variables.metadata.Query = Query;
	variables.metadata.IteratorCount = 0;
	return THIS;
}

</cfscript></cfcomponent>