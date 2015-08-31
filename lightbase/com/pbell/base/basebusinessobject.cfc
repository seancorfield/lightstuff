<cfcomponent extends="lightbase.com.pbell.base.baseobject" output="false"><cfscript>

// ***************** CONSTRUCTOR *****************

function init ( MetadataObject , DataTypeFacade , DAO , Validator , ErrorCollection ) {
	super.init();
	variables.Metadata = arguments.MetadataObject;
	variables.DAO = arguments.DAO;
	variables.Validator = arguments.Validator;
	variables.DataTypeFacade = arguments.DataTypeFacade;
	variables.ErrorCollection = arguments.ErrorCollection;
	variables.ErrorCollection._setMetadata( Metadata );
	variables.ErrorCollection._setValidator( Validator );
	variables.meta = structNew();
	return THIS;
}


// ***************** PUBLIC METHODS *****************

function _get( PropertyName ) {
	if ( structKeyExists( variables.meta , arguments.PropertyName ) ) {
		return variables.meta[ arguments.PropertyName ];
	};
	return variables.Metadata.get( arguments.PropertyName );
}

function _getPropertyNameList() {
	if ( structKeyExists( variables.meta , "PropertyNameList") ) {
		return variables.meta.PropertyNameList;
	}
	return variables.Metadata.get( _get("PropertyList") );
}

function _set( PropertyName , PropertyValue ) {
	variables.meta[ arguments.PropertyName ] = arguments.PropertyValue;
	return THIS;
}

function delete() {
	variables.DAO.deleteById( THIS.getId() );
	return THIS;
}

function errorDisplay() {
	return variables.errorcollection.ErrorDisplay( _getPropertyNameList() );
}

function field( PropertyName ) {
	var DataType = variables.Metadata.getProperty( PropertyName ).DataType;
	var DataTypeProperties = variables.Metadata.getProperty( PropertyName ).DataTypeProperties;
	return variables.DataTypeFacade.field( arguments.PropertyName , get( PropertyName ) , DataType , DataTypeProperties );
}

function format( PropertyName ) {
	var DataType = variables.Metadata.getProperty( PropertyName ).DataType;
	var DataTypeProperties = variables.Metadata.getProperty( PropertyName ).DataTypeProperties;
	return variables.DataTypeFacade.format( arguments.PropertyName , get( PropertyName ) , DataType , DataTypeProperties );
}

function getId() {
	return get( _get( "IdPropertyName" ) );
}

function isValidObject( ValidationContextList ) {
	return variables.errorcollection.isValidObject( _getPropertyNameList() , THIS , arguments.ValidationContextList );
}

function load( DataToLoad ) {
	if (isStruct( arguments.DatatoLoad ) ) {
		loadStruct( arguments.DatatoLoad );
		return THIS;
	}
	if (isQuery( arguments.DatatoLoad ) ) {
		loadQuery( arguments.DatatoLoad );
		return THIS;
	}
	dump("No idea what this is"); abort();
}

function loadfromEvent( Event ) {
	var i = 0;
	var PropertyName = "";
	var PropertyNameList = THIS._getPropertyNameList();
	for ( i = 1 ; i lte listlen( PropertyNameList ) ; i++ ) { 
		PropertyName = ListGetAt( PropertyNameList , i );
		processField( PropertyName , event );
	};
	set( _get( "IdPropertyName" ) , event.getId() );
};

function processField( PropertyName , Event ) {
	var DataType = variables.Metadata.getProperty( PropertyName ).DataType;
	var DataTypeProperties = variables.Metadata.getProperty( PropertyName ).DataTypeProperties;
	var FieldValue = variables.DataTypeFacade.processField( arguments.PropertyName , arguments.Event , DataType , DataTypeProperties );
	set( arguments.PropertyName , FieldValue );
}

function save() {
	variables.DAO.save( THIS.asStruct() );
	return THIS;
}

function title( PropertyName ) {
	return variables.Metadata.getProperty( PropertyName ).title;
}

function toString( ) {
	var Title = "";
	var i = 0;
	var PropertyName = "";
	var TitleList = variables.metadata.getTitleList()
	for ( i = 1 ; i lte listlen( TitleList ) ; i++ ) { 
		PropertyName = ListGetAt( TitleList , i );
		Title = ListAppend( Title , get( PropertyName ) , " " );
	};
	return Title;
}


// ***************** PRIVATE METHODS *****************

function loadQuery( Query ) {
	var cols = ListToArray( Query.columnlist );
	var col = 1;
	for( col = 1; col LTE arraylen( cols ); col++ ) {
		variables.instance[ cols[ col ] ] = Query[ cols[ col ] ][ 1 ];
	}
}

function loadStruct( DataToLoad ) {
	structAppend( variables.instance , arguments.DataToLoad );
}


// ***************** ON MISSING METHOD *****************

function onMissingMethod( MissingMethodName , MissingMethodArguments ) {
	var PropertyName = "";
	if ( left( MissingMethodName , 7 ) EQ "display" ) {
		PropertyName = right( MissingMethodName , ( len( MissingMethodName ) - 7 ) );
		return display( PropertyName );
	};
	if ( left( MissingMethodName , 5 ) EQ "field" ) {
		PropertyName = right( MissingMethodName , ( len( MissingMethodName ) - 5 ) );
		return field( PropertyName );
	};
	if ( left( MissingMethodName , 3 ) EQ "get" ) {
		PropertyName = right( MissingMethodName , ( len( MissingMethodName ) - 3 ) );
		return get( PropertyName );
	};
	if ( left( MissingMethodName , 3 ) EQ "set" ) {
		PropertyName = right( MissingMethodName , ( len( MissingMethodName ) - 3 ) );
		return set( PropertyName , MissingMethodArguments[1] );
	};
	if ( left( MissingMethodName , 4 ) EQ "_get" ) {
		PropertyName = right( MissingMethodName , ( len( MissingMethodName ) - 4 ) );
		return _get( PropertyName );
	};
	if ( left( MissingMethodName , 4 ) EQ "_set" ) {
		PropertyName = right( MissingMethodName , ( len( MissingMethodName ) - 4 ) );
		return _set( PropertyName , MissingMethodArguments[1] );
	};
		dump("No such method (#MissingMethodName#)");
}

</cfscript></cfcomponent>