<cfcomponent extends="lightbase.com.pbell.meta.basemetaclass" output="false"><cfscript>

// ***************** CONSTRUCTOR *****************
function init ( MetadataObject ) {
	super.init( MetadataObject );
	variables.ClassType = "Validator";
	return THIS;
}


// ***************** PUBLIC METHODS *****************

function _propertyValuesMatch ( FirstPropertyName , SecondPropertyName , Object ) {
	if ( arguments.Object.get( arguments.FirstPropertyName ) NEQ arguments.Object.get( arguments.SecondPropertyName ) ) {
		return "PropertiesDontMatch";
	}
	return "";
}


// ***************** PRIVATE METHODS *****************


</cfscript></cfcomponent>