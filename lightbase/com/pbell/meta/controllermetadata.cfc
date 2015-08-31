<cfcomponent name="basecontrollermetadata" extends="basemetadata" output="false"><cfscript>

// ***************** CONSTRUCTOR *****************
function init ( ControllerName , ApplicationMetadata ) {
	var ControllerXMLFilePath = expandPath("/#application.applicationname#/config/controller/#ControllerName#.xml");
	variables.ApplicationMetadata = arguments.ApplicationMetadata;
	super.init( "controller" , "methods" , ControllerXmlFilePath )
	return THIS;
}

</cfscript></cfcomponent>