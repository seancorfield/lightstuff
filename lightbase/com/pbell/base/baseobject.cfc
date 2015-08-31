<cfcomponent output="false"><cfscript>

// ***************** CONSTRUCTOR *****************
function init () {
	variables.instance = structNew();
	return THIS;
}

// ***************** PUBLIC METHODS *****************

function asStruct() {
	return variables.instance;
}

function get( PropertyName ) {
	if ( structKeyExists( variables , "get#arguments.PropertyName#" ) ) {
		return evaluate( "get#arguments.PropertyName#()");
	}
	return variables.instance[ arguments.PropertyName ];
}

function set( PropertyName , PropertyValue ) {
	if ( structKeyExists( variables , "set#arguments.PropertyName#" ) ) {
		evaluate( "set#PropertyName#( arguments.PropertyValue )");
	}
	else {
		variables.instance[ arguments.PropertyName ] = arguments.PropertyValue;
	}
	return THIS;
}



// ***************** PRIVATE METHODS *****************

function onMissingMethod( MissingMethodName , MissingMethodArguments ) {
	var PropertyName = "";
	if ( left( MissingMethodName , 3 ) EQ "get" ) {
		PropertyName = right( MissingMethodName , ( len( MissingMethodName ) - 3 ) );
		return get( PropertyName );
	};
	if ( left( MissingMethodName , 3 ) EQ "set" ) {
		PropertyName = right( MissingMethodName , ( len( MissingMethodName ) - 3 ) );
		return set( PropertyName , MissingMethodArguments[1] );
	};
		dump("No such method (#MissingMethodName#)");
}

</cfscript>
<cffunction name="abort" output="false" returntype="void" access="private">
	<cfabort>
</cffunction>
</cfcomponent>