<cfcomponent output="false"><cfscript>
	
// ***************** CONSTRUCTOR *****************

function init ( MetadataObject ) {
	variables.Metadata = arguments.MetadataObject;
	variables.ClassName = getMetadata( this ).Name;
	variables.ObjectName = variables.Metadata.getName();
	return THIS;
}


// ***************** PUBLIC METHODS *****************

function hasMethod( MethodName ) {
	if ( variables.Metadata.hasMethod( MethodName ) OR structKeyExists( this , arguments.MethodName )) {
		return true;
	};
	return false;
}

function metaGet( PropertyName ) {
	return variables.Metadata.get( arguments.PropertyName );
}


// ***************** PRIVATE METHODS *****************

function setDefault ( MethodProperties , PropertyName , DefaultValue ) {
	var MethodProperties = arguments.MethodProperties;
	if ( NOT structKeyExists( MethodProperties , arguments.PropertyName ) ) {MethodProperties[ arguments.PropertyName ] = arguments.DefaultValue;};
	return MethodProperties;
}

function setMethodDefaults( MethodProperties ) {
	return arguments.MethodProperties;
}

// ***************** ON MISSING METHOD *****************

function onMissingMethod( MissingMethodName , MissingMethodArguments ) {
	var MethodProperties = structNew();
	if ( variables.Metadata.hasMethod( MissingMethodName) ) {
		// If there is a real or XML method for the method requested
		MethodProperties = variables.Metadata.getMethodProperties( MissingMethodName );
		MissingMethodArguments.TagName = MethodProperties.TagName;
		structAppend( MethodProperties , MissingMethodArguments );
		MethodProperties = setMethodDefaults( MethodProperties );
		return evaluate("_#MethodProperties.TagName#(argumentCollection=MethodProperties)");
	}
	else {
		if ( structKeyExists( variables , "_#MissingMethodName#" ) ) {
			// If there is a base method (like _getByFilter) matching the method requested
			structAppend( MethodProperties , MissingMethodArguments )
			MethodProperties = setMethodDefaults( MethodProperties );
			return evaluate("_#MissingMethodName#(argumentCollection=MethodProperties)");
		}
		else {
			dump("No such method (#MissingMethodName# in #variables.ObjectName##variables.ClassType#)");
		}
	}
}
</cfscript>
<cffunction name="abort" output="false" returntype="void" access="private">
	<cfabort>
</cffunction>
</cfcomponent>