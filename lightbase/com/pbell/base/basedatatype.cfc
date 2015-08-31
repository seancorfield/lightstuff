<cfcomponent output="false"><cfscript>

// ***************** CONSTRUCTOR *****************
function init() {
	return THIS;
}


// ***************** PUBLIC METHODS *****************
function format( PropertyName , PropertyValue , DataTypeProperties ) {
	var Properties = ProcessDataTypeProperties( arguments.DataTypeProperties );
	return PropertyValue;
}

function field( PropertyName , PropertyValue , DataTypeProperties ) {
	var Properties = ProcessDataTypeProperties( arguments.DataTypeProperties );
	return "<input type='text' name='#PropertyName#' value='#PropertyValue#' />";
}

function processField( PropertyName , Event , DataTypeProperties ) {
	var Properties = ProcessDataTypeProperties( arguments.DataTypeProperties );
	return arguments.Event.get( PropertyName );
}

function validateProperty( PropertyName , PropertyValue , DataTypeProperties ) {
	// Return pipe delimited list of error messages
	var Properties = ProcessDataTypeProperties( arguments.DataTypeProperties );
	return "";
}


// ***************** PRIVATE METHODS *****************
function ProcessDataTypeProperties( DataTypeProperties ) {
	var PropertiesStruct = structNew();
	var PropertyNameValuePair = "";
	var PropertyName = "";
	var PropertyValue = "";
	var i = 0;
	for ( i = 1 ; i lte listlen( DataTypeProperties ) ; i++ ) { 
		PropertyNameValuePair = ListGetAt( DataTypeProperties , i );
		PropertyName = ListGetAt( PropertyNameValuePair , 1 , "=" );
		PropertyValue = ListGetAt( PropertyNameValuePair , 2 , "=" );
		PropertiesStruct[ PropertyName ] = PropertyValue;
	};
	return PropertiesStruct;
}

</cfscript></cfcomponent>