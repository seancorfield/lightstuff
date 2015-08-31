<cfcomponent output="false"><cfscript>

// ***************** CONSTRUCTOR *****************

function init() {
	return THIS;
}


// ***************** PUBLIC METHODS *****************
function format( PropertyName , PropertyValue , DataType , DataTypeProperties ) {
	return variables[ DataType & "DataType" ].format( arguments.PropertyName , arguments.PropertyValue , arguments.DataTypeProperties );
}

function field( PropertyName , PropertyValue , DataType , DataTypeProperties ) {
	return variables[ DataType & "DataType" ].field( arguments.PropertyName , arguments.PropertyValue , arguments.DataTypeProperties );
}

function processField( PropertyName , Event , DataType , DataTypeProperties ) {
	return variables[ DataType & "DataType" ].processField( arguments.PropertyName , arguments.Event , arguments.DataTypeProperties );
}

function validateProperty( PropertyName , PropertyValue , DataType , DataTypeProperties ) {
	return variables[ DataType & "DataType" ].validateProperty( arguments.PropertyName , arguments.PropertyValue , arguments.DataTypeProperties );
}

// ***************** PRIVATE METHODS *****************

</cfscript>
<cffunction name="abort" output="false" returntype="void" access="private">
	<cfabort>
</cffunction>
</cfcomponent>