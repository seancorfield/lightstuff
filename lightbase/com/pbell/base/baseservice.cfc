<cfcomponent extends="lightbase.com.pbell.meta.basemetaclass" output="false"><cfscript>

// ***************** CONSTRUCTOR *****************

function init ( MetadataObject , DAO ) {
	super.init( MetadataObject );
	variables.DAO = arguments.DAO;
	variables.ObjectName = variables.Metadata.getName();
	variables.ClassType = "Service";
	return THIS;
}


// ***************** PUBLIC METHODS *****************

function _getByFilter ( Filter , PropertyNameList , Order) {
	var BusinessObject = newObject()._setPropertyNameList( arguments.PropertyNameList );
	var Query = DAO.getByFilter( argumentCollection=arguments );
	var Iterator = beanfactory.getBean( "iterator" );
	return Iterator.load( BusinessObject , Query );
}

function _getByProperty ( PropertyName , PropertyValue ) {
	var Query = DAO.getByProperty( argumentCollection=arguments );
	return newObject().load( Query );
}

function newObject () {
	return beanfactory.getBean( variables.ObjectName );
}


// ***************** PRIVATE METHODS *****************

function setMethodDefaults( MethodProperties ) {
	var MethodType = MethodProperties.TagName;
	var MethodProperties = arguments.MethodProperties;
	switch( MethodType ) {
		
		case "getByFilter" : {
			MethodProperties = setDefault( MethodProperties , "order" , variables.Metadata.getDefaultOrder() );
			MethodProperties = setDefault( MethodProperties , "filter" , "1=1" );
		}

		case "getById" : {
			MethodProperties = setDefault( MethodProperties , "PropertyName" , "Id" );
		}

	}
	return MethodProperties;
}

</cfscript></cfcomponent>