<cfcomponent extends="basemetadata" output="false"><cfscript>
// ***************** CONSTRUCTOR *****************
function init ( ModelName , ApplicationMetadata ) {
	var ModelXMLFilePath = expandPath("/#application.applicationname#/config/model/#arguments.ModelName#.xml");
	variables.ApplicationMetadata = arguments.ApplicationMetadata;
	super.init( "model" , "properties,relationships,methods,validationContexts,validationRules" , ModelXMLFilePath );
	return THIS;
}


// ***************** PUBLIC METHODS *****************

function getDataSource() {
	return variables.ApplicationMetadata.getDataSource();
}

function getProperty( PropertyName ) {
	return variables.instance.properties[ arguments.PropertyName ];
}

function getValidationContext( ValidationContextName ) {
	return variables.instance.validationContexts[ arguments.ValidationContextName ];
}

function getValidationRule( ValidationRuleName ) {
	return variables.instance.validationRules[ arguments.ValidationRuleName ];
}

</cfscript></cfcomponent>