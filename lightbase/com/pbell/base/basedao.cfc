<cfcomponent extends="lightbase.com.pbell.meta.basemetaclass" output="false"><cfscript>

// ***************** CONSTRUCTOR *****************
function init ( MetadataObject ) {
	super.init( MetadataObject );
	variables.Datasource = Metadata.getDataSource();
	variables.ClassType = "DAO";
	variables.meta = structNew();
	variables.meta.TableName = variables.Metadata.getTableName();
	variables.meta.IdPropertyName = metaGet( "IdPropertyName" );
	return THIS;
}


// ***************** PUBLIC METHODS *****************

function deleteById( Id ) {
	var SQL = "DELETE FROM #variables.meta.TableName# WHERE #variables.meta.IdPropertyName# = '#arguments.Id#'"
	return executeSQL( SQL );
}

function getByFilter( Filter , PropertyNameList , Order ) {
	var FullPropertyNameList = ListAppend( arguments.PropertyNameList , variables.meta.IdPropertyName );
	var SQL = "SELECT #FullPropertyNameList# FROM #variables.meta.TableName# WHERE #arguments.Filter# ORDER BY #arguments.Order#";
	return executeSQL( SQL );
}

function getByProperty( PropertyName , PropertyValue ) {
	if( PropertyName EQ "Id" ) { PropertyName = variables.meta.IdPropertyName;};
	var SQL = "SELECT * FROM #variables.meta.TableName# WHERE #arguments.PropertyName# = '#arguments.PropertyValue#'";
	return executeSQL( SQL );
}

function save( StructToSave ) {
	if ( arguments.StructToSave.UserId EQ 0 ) {
		return insertRecord( StructToSave );
	} 
	else {
		return updateRecord( StructToSave );
	};
}

// ***************** PRIVATE METHODS *****************

function insertRecord( StructToSave ) {
	var SQL = "";
	var First = true;
	var GetLastIdSQL = "SELECT LAST_INSERT_ID() AS Id"; 
	StructDelete( arguments.StructToSave , variables.meta.IdPropertyName );
	SQL = "INSERT INTO #variables.meta.TableName# (#StructKeyList( StructToSave )#) values ( ";
	for (key in arguments.StructToSave ) {
		if (not First) { SQL &= " , ";};
		SQL &= "'#arguments.StructToSave[key]#'";
		First=false;
	};
	SQL &= " ) ";
	executeSQL( SQL );
	return executeSQL ( GetLastIdSQL );
}

function updateRecord( StructToSave ) {
	var SQL = "UPDATE #variables.meta.TableName# SET ";
	var First = true;
	for (key in arguments.StructToSave ) {
		if (not First) { SQL &= " , ";};
		SQL &= "#key# = '#arguments.StructToSave[key]#'";
		First=false;
	};
	SQL &= " WHERE #variables.meta.IdPropertyName# = #arguments.StructToSave[ variables.meta.IdPropertyName ]# ";
	executeSQL( SQL ); 
	return StructToSave[ variables.meta.IdPropertyName ];
}

</cfscript>
<cffunction name="executeSQL" returntype="any" output="false">
	<cfargument name="SQL" required="true" type="string">
	<cfset var Query = "">
	<cfquery name="Query" datasource="#variables.DataSource#" result="Result">
		#preservesinglequotes( SQL )#
	</cfquery>
	<cfreturn Query>
</cffunction>

</cfcomponent>