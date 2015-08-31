<cfcomponent output="false"><cfscript>
// ***************** CONSTRUCTOR *****************

function init ( ObjectType , ObjectCollectionsList , ObjectXmlFilePath ) {
	variables.Instance = StructNew();
	variables.ObjectType = arguments.ObjectType;
	variables.ObjectCollectionsList = arguments.ObjectCollectionsList;
	loadXml( arguments.ObjectXmlFilePath );
	return THIS;
}


// ***************** PUBLIC METHODS *****************

function asStruct() {
	return variables.instance;
}

function get( PropertyName ) {
	return variables.instance.object[ arguments.PropertyName ];
}

function getMethodProperties( MethodName ) {
	return variables.Instance.methods[ arguments.MethodName ];
}

function getMethodList() {
	return structKeyList( variables.Instance.methods );
}

function hasMethod( MethodName ) {
	// Whether or not I have a method of that name loaded from the XML metadata
	if ( structkeyexists( variables.Instance.methods , MethodName ) ) {
		return true;
	}
	else {
		return false;
	};
}


// ***************** PRIVATE METHODS *****************

function loadXml ( ObjectXmlFilePath ) {
	var XmlString = readFile( arguments.ObjectXmlFilePath );
	var XmlDocument = XMLParse( XmlString );
	var i = 0;
	variables.ObjectXml = XMLSearch( XmlDocument , "//#variables.ObjectType#/" )[1];
	setObjectAttributes();
	for (i = 1 ; i lte listlen( variables.ObjectCollectionsList ) ; i++ ){
		setCollection( listGetAt( variables.ObjectCollectionsList , i ) );
	}
	if ( structKeyExists( variables.ObjectXml.XmlAttributes , "extends" ) ) {
		loadXml( getExtendsXMLFilePath( variables.ObjectXml.XmlAttributes.extends , arguments.ObjectXmlFilePath ) );
	};
}

function setAttributes ( AttributeType , Xml ) {
	var Attributes = arguments.Xml.XmlAttributes;
	var AttributeName = Attributes["name"];
		if ( NOT structKeyExists( variables.Instance , AttributeType ) ) {
			variables.Instance[ AttributeType ][ AttributeName ] = StructNew();
		};
		if ( NOT structKeyExists( variables.Instance[ AttributeType ] , AttributeName ) ) {
			variables.Instance[ AttributeType ][ AttributeName ] = StructNew();
		};
		if ( NOT structKeyExists( variables.Instance[ AttributeType ][ AttributeName ] , "TagName" ) ) {
			variables.Instance[ AttributeType ][ AttributeName ]["TagName"] = arguments.Xml.XmlName;
		};
	for (key in Attributes) {
		if ( NOT structKeyExists( variables.Instance[ AttributeType ][ AttributeName ] , key ) ) {
			variables.Instance[ AttributeType ][ AttributeName ][ key ] = Attributes[ key ];
		};
	}
}

function setCollection ( CollectionType ) {
	var CollectionArray =  XMLSearch( variables.ObjectXml , "/#variables.ObjectType#/#arguments.CollectionType#/*" );
	var j = 1;

//	variables.Instance[ arguments.CollectionType ] = structNew();

	for ( j = 1 ; j <= arrayLen( CollectionArray ) ; j++ ) {
		setAttributes( arguments.CollectionType , CollectionArray[j] );
	}
}

function setObjectAttributes () {
	var Attributes = variables.ObjectXml.XmlAttributes;
	if ( NOT structKeyExists( variables.Instance , "Object" ) ) {
	variables.Instance.Object = StructNew();
	};
	variables.Instance.Object["TagName"] = variables.ObjectXml.XmlName;
	for (key in Attributes) {
		if ( NOT structKeyExists( variables.Instance.Object , key ) ) {
			variables.Instance.Object[ key ] = Attributes[ key ];
		}
		else {
			if( key EQ "extends") {
			variables.Instance.Object.extends = ListAppend( variables.Instance.Object.extends , Attributes.extends );
			};
		};
	};
}


// ***************** PRIVATE METHODS *****************

function getExtendsXMLFilePath( ExtendsFileName , ObjectXmlFilePath ) {
	var LastItem = ListLen( arguments.ObjectXmlFilePath , "/" );
	return	ListDeleteAt( arguments.ObjectXmlFilePath , LastItem , "/" ) & "/#ExtendsFileName#.xml";
};


// ***************** ON MISSING METHOD *****************

function onMissingMethod( MissingMethodName , MissingMethodArguments ) {
	var PropertyName = "";
	if ( left( MissingMethodName , 3 ) EQ "get" ) {
		PropertyName = right( MissingMethodName , ( len( MissingMethodName ) - 3 ) );
		return get( PropertyName );
	};
		dump("No such method (#MissingMethodName#)");
}
</cfscript>

<cffunction name="readFile" returntype="string" access="private" output="false">
	<cfargument name="FileName" required="true" type="string">
	<cfset var FileContents = "">
	<cffile action="read" file="#arguments.FileName#" variable="FileContents">
	<cfreturn FileContents>
</cffunction>

<cffunction name="abort" returntype="void" access="private" output="false">
	<cfabort>
</cffunction>

</cfcomponent>