<cfcomponent name="applicationmetadata" extends="basemetadata" output="false"><cfscript>

// ***************** CONSTRUCTOR *****************
function init () {
	var ApplicationXMLFilePath = expandPath("/#application.applicationname#/config/application.xml");
	super.init( "application" , "inputProperties" , ApplicationXMLFilePath );
	return THIS;
}


// ***************** PUBLIC METHODS *****************

function getDataSource() {
	if ( structKeyExists( variables.instance.Object , "DataSource" ) ) {
		return variables.instance.Object.DataSource;
	}
	return variables.instance.Object.Name;
}

function getinputPropertyDefaultValue( PropertyName ) {
	if ( structKeyExists( variables.instance.inputProperties , arguments.PropertyName ) ) {
		return variables.instance.inputProperties[ arguments.PropertyName ].DefaultValue;
	}
	return "";
}

</cfscript></cfcomponent>