<cfcomponent extends="lightbase.lightwire.BaseConfigObject" output="false" hint="The LightWire configuration bean for LightBase."><cfscript>

// ***************** CONSTRUCTOR *****************

function init( ApplicationName ) {
	variables.applicationName = arguments.ApplicationName;
	Super.init();
	loadObjects( "controller" );
	loadObjects( "model" );
	loadMiscFrameworkBeans();
	loadDataTypes();
	setLazyLoad("false");
	//dump( getConfigStruct() );
	return THIS;
}

// ***************** PRIVATE METHODS *****************

function loadObjects ( ObjectType ) {
	var ObjectNameList = getObjectNameList( arguments.ObjectType );
	var ObjectName = "";
	var i = 0;
	for ( i = 1 ; i lte listlen( ObjectNameList ) ; i++ ) { 
		ObjectName = ListGetAt( ObjectNameList , i );
		if (objectType EQ "model") {
			loadModel( ObjectName );
		}
		else {
			loadController( ObjectName );
		}
	};	
}

function loadController( ObjectName ) {
	loadObjectXMLBean( arguments.ObjectName , "controller" );
	if ( ObjectExists( arguments.ObjectName , "controller" ) ) {
		addSingleton("#variables.ApplicationName#.com.controller.#arguments.ObjectName#" , "#arguments.ObjectName#Controller");
	}
	else {
		addSingleton("lightbase.com.pbell.base.basecontroller" , "#arguments.ObjectName#Controller");
	};
	addConstructorDependency( "#arguments.ObjectName#Controller", "#arguments.ObjectName#ControllerMetadata" , "MetadataObject" );
}

function loadModel( ObjectName ) {
	loadObjectXMLBean( arguments.ObjectName , "model" );
	loadModelClass( arguments.ObjectName , "service" );
	loadModelClass( arguments.ObjectName , "dao" );
	loadModelClass( arguments.ObjectName , "validator" );
	addConstructorDependency( "#arguments.ObjectName#service" , "#arguments.ObjectName#DAO" , "DAO");
	loadBusinessObject( arguments.ObjectName );	
}

function loadModelClass( ObjectName , ObjectType ) {
	var ClassName = arguments.ObjectName & arguments.ObjectType;
	if ( ObjectExists( ClassName , "model" ) ) {
		addSingleton("#variables.ApplicationName#.com.model.#ClassName#");
	}
	else {
		addSingleton("lightbase.com.pbell.base.base#arguments.ObjectType#" , ClassName );
	};
	addConstructorDependency( ClassName , "#arguments.ObjectName#ModelMetadata" , "MetadataObject" );
}

function loadBusinessObject( ObjectName ) {
	if ( ObjectExists( arguments.ObjectName , "" ) ) {
		addTransient("#variables.ApplicationName#.com.model.#arguments.ObjectName#");
	}
	else {
		addTransient("lightbase.com.pbell.base.basebusinessobject" , arguments.ObjectName );
	};
	addConstructorDependency( arguments.ObjectName , "#arguments.ObjectName#ModelMetadata" , "MetadataObject" );
	addConstructorDependency( arguments.ObjectName , "#arguments.ObjectName#DAO" , "DAO" );
	addConstructorDependency( arguments.ObjectName , "#arguments.ObjectName#Validator" , "Validator" );
	addConstructorDependency( arguments.ObjectName , "datatypefacade" );
	addConstructorDependency( arguments.ObjectName , "errorcollection" );
}

function loadObjectXMLBean( ObjectName , ObjectType ) {
	addSingleton("lightbase.com.pbell.meta.#arguments.ObjectType#metadata" , "#arguments.ObjectName##arguments.ObjectType#Metadata");
	addConstructorProperty( "#arguments.ObjectName##arguments.ObjectType#Metadata", "#arguments.ObjectType#Name" , arguments.ObjectName );
	addConstructorDependency( "#arguments.ObjectName##arguments.ObjectType#Metadata" , "ApplicationMetadata" );
}


function ObjectExists( ObjectName , ObjectType ) {
	return FileExists( expandPath("/#variables.applicationName#/com/#arguments.ObjectType#/#arguments.ObjectName#.cfc") );
}

function loadModels() {
	var ModelNameList = getObjectNameList( "model" );
	var ModelName = "";
	var i=0;
	for (i = 1 ; i lte listlen( ModelNameList ) ; i++ ) { 
		ModelName = ListGetAt( ModelNameList , i );
		loadModel( ModelName );
	};	
}

function loadMiscFrameworkBeans() {
	addSingleton( "lightbase.com.pbell.meta.applicationmetadata" );
	addTransient( "#variables.applicationName#.com.event" , "event" );
	addConstructorDependency( "event" , "ApplicationMetaData" );
	addTransient( "lightbase.com.pbell.iterator" , "iterator" );
	addSingleton( "lightbase.com.pbell.datatypefacade" );
	addTransient( "lightbase.com.pbell.errorcollection" , "errorcollection" );
	addConstructorDependency( "errorcollection" , "DataTypeFacade" );
}


function loadDataTypes (  ) {
	var DataTypesList = getDataTypesList();
	var DataTypePath = "";
	var DataTypeName = "";
	var i = 0;
	for ( i = 1 ; i lte listlen( DataTypesList ) ; i++ ) { 
		DataTypePath = listGetAt( DataTypesList , i );
		DataTypeName = ListLast( DataTypePath , "." ) & "DataType";
		addSingleton( "#DataTypePath#" , DataTypeName );
		addMixinDependency( "DataTypeFacade", DataTypeName );
	}
}

</cfscript>
<cffunction name="getObjectNameList" returntype="String">
	<cfargument name="ObjectType" type="string" required="true">
	<cfset var ObjectConfigDirectoryPath = GetDirectoryFromPath("/#ApplicationName#/config/#arguments.ObjectType#/")>
	<cfset var ObjectQuery = "">
	<cfset var ObjectNameList = "">
	<cfdirectory action="list" directory="#ObjectConfigDirectoryPath#" name="ObjectQuery">
	<cfloop query="ObjectQuery">
		<cfif left( Name , 8) NEQ "abstract">
		<!--- Don't include abstract models which are only to be extended--->
		<cfset ObjectNameList = ListAppend(ObjectNameList , ListGetAt( Name , 1 , "."))>
		</cfif>
	</cfloop>
	<cfreturn ObjectNameList>
</cffunction>
<cffunction name="getDataTypesList" returntype="String">
	<cfset var SystemDataTypeDirectoryPath = expandPath("/lightbase/com/pbell/datatype/")>
	<cfset var CustomDataTypeDirectoryPath = expandPath("/#ApplicationName#/com/datatype/")>
	<cfset var DataTypeQuery = "">
	<cfset var DataTypesList = "">
	<cfset var NameList = "">
	<cfdirectory action="list" directory="#CustomDataTypeDirectoryPath#" name="DataTypeQuery">
	<cfloop query="DataTypeQuery">
		<cfset DataTypesList = ListAppend( DataTypesList , "#ApplicationName#.com.datatype.#ListGetAt( Name , 1 , ".")#" )>
		<cfset NameList = ListAppend( NameList , ListGetAt( Name , 1 , ".") )>
	</cfloop>
	<cfdirectory action="list" directory="#SystemDataTypeDirectoryPath#" name="DataTypeQuery">
	<cfloop query="DataTypeQuery">
		<cfif NOT ListFindNoCase( NameList , ListGetAt( Name , 1 , ".") )>
			<!--- Only add system data types if not present in the projects data types --->
			<cfset DataTypesList = ListAppend( DataTypesList , "lightbase.com.pbell.datatype.#ListGetAt( Name , 1 , ".")#" )>
		</cfif>
	</cfloop>
	<cfreturn DataTypesList>
</cffunction>
</cfcomponent>