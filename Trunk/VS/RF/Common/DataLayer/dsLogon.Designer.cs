﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:2.0.50727.5456
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

// 
// This source code was auto-generated by Microsoft.CompactFramework.Design.Data, Version 2.0.50727.5456.
// 
namespace DataLayer {
    using System;
    using System.Data;
    
    
    /// <summary>
    ///Represents a strongly typed in-memory cache of data.
    ///</summary>
    [global::System.ComponentModel.DesignerCategoryAttribute("code")]
    [global::System.Xml.Serialization.XmlSchemaProviderAttribute("GetTypedDataSetSchema")]
    [global::System.Xml.Serialization.XmlRootAttribute("dsLogon")]
    public partial class dsLogon : global::System.Data.DataSet {
        
        private employeeDataTable tableemployee;
        
        private global::System.Data.SchemaSerializationMode _schemaSerializationMode = global::System.Data.SchemaSerializationMode.IncludeSchema;
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        public dsLogon() {
            this.BeginInit();
            this.InitClass();
            global::System.ComponentModel.CollectionChangeEventHandler schemaChangedHandler = new global::System.ComponentModel.CollectionChangeEventHandler(this.SchemaChanged);
            base.Tables.CollectionChanged += schemaChangedHandler;
            base.Relations.CollectionChanged += schemaChangedHandler;
            this.EndInit();
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        public employeeDataTable employee {
            get {
                return this.tableemployee;
            }
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        public override global::System.Data.SchemaSerializationMode SchemaSerializationMode {
            get {
                return this._schemaSerializationMode;
            }
            set {
                this._schemaSerializationMode = value;
            }
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        public new global::System.Data.DataTableCollection Tables {
            get {
                return base.Tables;
            }
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        public new global::System.Data.DataRelationCollection Relations {
            get {
                return base.Relations;
            }
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        protected override void InitializeDerivedDataSet() {
            this.BeginInit();
            this.InitClass();
            this.EndInit();
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        public override global::System.Data.DataSet Clone() {
            dsLogon cln = ((dsLogon)(base.Clone()));
            cln.InitVars();
            cln.SchemaSerializationMode = this.SchemaSerializationMode;
            return cln;
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        protected override bool ShouldSerializeTables() {
            return false;
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        protected override bool ShouldSerializeRelations() {
            return false;
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        protected override void ReadXmlSerializable(global::System.Xml.XmlReader reader) {
            if ((this.DetermineSchemaSerializationMode(reader) == global::System.Data.SchemaSerializationMode.IncludeSchema)) {
                this.Reset();
                global::System.Data.DataSet ds = new global::System.Data.DataSet();
                ds.ReadXml(reader);
                if ((ds.Tables["employee"] != null)) {
                    base.Tables.Add(new employeeDataTable(ds.Tables["employee"]));
                }
                this.DataSetName = ds.DataSetName;
                this.Prefix = ds.Prefix;
                this.Namespace = ds.Namespace;
                this.Locale = ds.Locale;
                this.CaseSensitive = ds.CaseSensitive;
                this.EnforceConstraints = ds.EnforceConstraints;
                this.Merge(ds, false, global::System.Data.MissingSchemaAction.Add);
                this.InitVars();
            }
            else {
                this.ReadXml(reader);
                this.InitVars();
            }
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        protected override global::System.Xml.Schema.XmlSchema GetSchemaSerializable() {
            global::System.IO.MemoryStream stream = new global::System.IO.MemoryStream();
            this.WriteXmlSchema(new global::System.Xml.XmlTextWriter(stream, null));
            stream.Position = 0;
            return global::System.Xml.Schema.XmlSchema.Read(new global::System.Xml.XmlTextReader(stream), null);
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        internal void InitVars() {
            this.InitVars(true);
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        internal void InitVars(bool initTable) {
            this.tableemployee = ((employeeDataTable)(base.Tables["employee"]));
            if ((initTable == true)) {
                if ((this.tableemployee != null)) {
                    this.tableemployee.InitVars();
                }
            }
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        private void InitClass() {
            this.DataSetName = "dsLogon";
            this.Prefix = "";
            this.Namespace = "http://tempuri.org/dsLogon.xsd";
            this.EnforceConstraints = true;
            this.SchemaSerializationMode = global::System.Data.SchemaSerializationMode.IncludeSchema;
            this.tableemployee = new employeeDataTable();
            base.Tables.Add(this.tableemployee);
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        private bool ShouldSerializeemployee() {
            return false;
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        private void SchemaChanged(object sender, global::System.ComponentModel.CollectionChangeEventArgs e) {
            if ((e.Action == global::System.ComponentModel.CollectionChangeAction.Remove)) {
                this.InitVars();
            }
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        public static global::System.Xml.Schema.XmlSchemaComplexType GetTypedDataSetSchema(global::System.Xml.Schema.XmlSchemaSet xs) {
            dsLogon ds = new dsLogon();
            global::System.Xml.Schema.XmlSchemaComplexType type = new global::System.Xml.Schema.XmlSchemaComplexType();
            global::System.Xml.Schema.XmlSchemaSequence sequence = new global::System.Xml.Schema.XmlSchemaSequence();
            global::System.Xml.Schema.XmlSchemaAny any = new global::System.Xml.Schema.XmlSchemaAny();
            any.Namespace = ds.Namespace;
            sequence.Items.Add(any);
            type.Particle = sequence;
            global::System.Xml.Schema.XmlSchema dsSchema = ds.GetSchemaSerializable();
            if (xs.Contains(dsSchema.TargetNamespace)) {
                global::System.IO.MemoryStream s1 = new global::System.IO.MemoryStream();
                global::System.IO.MemoryStream s2 = new global::System.IO.MemoryStream();
                try {
                    global::System.Xml.Schema.XmlSchema schema = null;
                    dsSchema.Write(s1);
                    for (global::System.Collections.IEnumerator schemas = xs.Schemas(dsSchema.TargetNamespace).GetEnumerator(); schemas.MoveNext(); ) {
                        schema = ((global::System.Xml.Schema.XmlSchema)(schemas.Current));
                        s2.SetLength(0);
                        schema.Write(s2);
                        if ((s1.Length == s2.Length)) {
                            s1.Position = 0;
                            s2.Position = 0;
                            for (; ((s1.Position != s1.Length) 
                                        && (s1.ReadByte() == s2.ReadByte())); ) {
                                ;
                            }
                            if ((s1.Position == s1.Length)) {
                                return type;
                            }
                        }
                    }
                }
                finally {
                    if ((s1 != null)) {
                        s1.Close();
                    }
                    if ((s2 != null)) {
                        s2.Close();
                    }
                }
            }
            xs.Add(dsSchema);
            return type;
        }
        
        public delegate void employeeRowChangeEventHandler(object sender, employeeRowChangeEvent e);
        
        /// <summary>
        ///Represents the strongly named DataTable class.
        ///</summary>
        [global::System.Xml.Serialization.XmlSchemaProviderAttribute("GetTypedTableSchema")]
        public partial class employeeDataTable : global::System.Data.TypedTableBase<employeeRow> {
            
            private global::System.Data.DataColumn columnname;
            
            private global::System.Data.DataColumn columnoperator_code;
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public employeeDataTable() {
                this.TableName = "employee";
                this.BeginInit();
                this.InitClass();
                this.EndInit();
            }
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            internal employeeDataTable(global::System.Data.DataTable table) {
                this.TableName = table.TableName;
                if ((table.CaseSensitive != table.DataSet.CaseSensitive)) {
                    this.CaseSensitive = table.CaseSensitive;
                }
                if ((table.Locale.ToString() != table.DataSet.Locale.ToString())) {
                    this.Locale = table.Locale;
                }
                if ((table.Namespace != table.DataSet.Namespace)) {
                    this.Namespace = table.Namespace;
                }
                this.Prefix = table.Prefix;
                this.MinimumCapacity = table.MinimumCapacity;
            }
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public global::System.Data.DataColumn nameColumn {
                get {
                    return this.columnname;
                }
            }
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public global::System.Data.DataColumn operator_codeColumn {
                get {
                    return this.columnoperator_code;
                }
            }
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public int Count {
                get {
                    return this.Rows.Count;
                }
            }
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public employeeRow this[int index] {
                get {
                    return ((employeeRow)(this.Rows[index]));
                }
            }
            
            public event employeeRowChangeEventHandler employeeRowChanging;
            
            public event employeeRowChangeEventHandler employeeRowChanged;
            
            public event employeeRowChangeEventHandler employeeRowDeleting;
            
            public event employeeRowChangeEventHandler employeeRowDeleted;
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public void AddemployeeRow(employeeRow row) {
                this.Rows.Add(row);
            }
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public employeeRow AddemployeeRow(string name, string operator_code) {
                employeeRow rowemployeeRow = ((employeeRow)(this.NewRow()));
                object[] columnValuesArray = new object[] {
                        name,
                        operator_code};
                rowemployeeRow.ItemArray = columnValuesArray;
                this.Rows.Add(rowemployeeRow);
                return rowemployeeRow;
            }
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public employeeRow FindByoperator_code(string operator_code) {
                return ((employeeRow)(this.Rows.Find(new object[] {
                            operator_code})));
            }
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public override global::System.Data.DataTable Clone() {
                employeeDataTable cln = ((employeeDataTable)(base.Clone()));
                cln.InitVars();
                return cln;
            }
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            protected override global::System.Data.DataTable CreateInstance() {
                return new employeeDataTable();
            }
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            internal void InitVars() {
                this.columnname = base.Columns["name"];
                this.columnoperator_code = base.Columns["operator_code"];
            }
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            private void InitClass() {
                this.columnname = new global::System.Data.DataColumn("name", typeof(string), null, global::System.Data.MappingType.Element);
                base.Columns.Add(this.columnname);
                this.columnoperator_code = new global::System.Data.DataColumn("operator_code", typeof(string), null, global::System.Data.MappingType.Element);
                base.Columns.Add(this.columnoperator_code);
                this.Constraints.Add(new global::System.Data.UniqueConstraint("Constraint1", new global::System.Data.DataColumn[] {
                                this.columnoperator_code}, true));
                this.columnname.AllowDBNull = false;
                this.columnname.MaxLength = 40;
                this.columnoperator_code.AllowDBNull = false;
                this.columnoperator_code.Unique = true;
                this.columnoperator_code.MaxLength = 5;
            }
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public employeeRow NewemployeeRow() {
                return ((employeeRow)(this.NewRow()));
            }
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            protected override global::System.Data.DataRow NewRowFromBuilder(global::System.Data.DataRowBuilder builder) {
                return new employeeRow(builder);
            }
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            protected override global::System.Type GetRowType() {
                return typeof(employeeRow);
            }
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            protected override void OnRowChanged(global::System.Data.DataRowChangeEventArgs e) {
                base.OnRowChanged(e);
                if ((this.employeeRowChanged != null)) {
                    this.employeeRowChanged(this, new employeeRowChangeEvent(((employeeRow)(e.Row)), e.Action));
                }
            }
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            protected override void OnRowChanging(global::System.Data.DataRowChangeEventArgs e) {
                base.OnRowChanging(e);
                if ((this.employeeRowChanging != null)) {
                    this.employeeRowChanging(this, new employeeRowChangeEvent(((employeeRow)(e.Row)), e.Action));
                }
            }
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            protected override void OnRowDeleted(global::System.Data.DataRowChangeEventArgs e) {
                base.OnRowDeleted(e);
                if ((this.employeeRowDeleted != null)) {
                    this.employeeRowDeleted(this, new employeeRowChangeEvent(((employeeRow)(e.Row)), e.Action));
                }
            }
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            protected override void OnRowDeleting(global::System.Data.DataRowChangeEventArgs e) {
                base.OnRowDeleting(e);
                if ((this.employeeRowDeleting != null)) {
                    this.employeeRowDeleting(this, new employeeRowChangeEvent(((employeeRow)(e.Row)), e.Action));
                }
            }
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public void RemoveemployeeRow(employeeRow row) {
                this.Rows.Remove(row);
            }
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public static global::System.Xml.Schema.XmlSchemaComplexType GetTypedTableSchema(global::System.Xml.Schema.XmlSchemaSet xs) {
                global::System.Xml.Schema.XmlSchemaComplexType type = new global::System.Xml.Schema.XmlSchemaComplexType();
                global::System.Xml.Schema.XmlSchemaSequence sequence = new global::System.Xml.Schema.XmlSchemaSequence();
                dsLogon ds = new dsLogon();
                global::System.Xml.Schema.XmlSchemaAny any1 = new global::System.Xml.Schema.XmlSchemaAny();
                any1.Namespace = "http://www.w3.org/2001/XMLSchema";
                any1.MinOccurs = new decimal(0);
                any1.MaxOccurs = decimal.MaxValue;
                any1.ProcessContents = global::System.Xml.Schema.XmlSchemaContentProcessing.Lax;
                sequence.Items.Add(any1);
                global::System.Xml.Schema.XmlSchemaAny any2 = new global::System.Xml.Schema.XmlSchemaAny();
                any2.Namespace = "urn:schemas-microsoft-com:xml-diffgram-v1";
                any2.MinOccurs = new decimal(1);
                any2.ProcessContents = global::System.Xml.Schema.XmlSchemaContentProcessing.Lax;
                sequence.Items.Add(any2);
                global::System.Xml.Schema.XmlSchemaAttribute attribute1 = new global::System.Xml.Schema.XmlSchemaAttribute();
                attribute1.Name = "namespace";
                attribute1.FixedValue = ds.Namespace;
                type.Attributes.Add(attribute1);
                global::System.Xml.Schema.XmlSchemaAttribute attribute2 = new global::System.Xml.Schema.XmlSchemaAttribute();
                attribute2.Name = "tableTypeName";
                attribute2.FixedValue = "employeeDataTable";
                type.Attributes.Add(attribute2);
                type.Particle = sequence;
                global::System.Xml.Schema.XmlSchema dsSchema = ds.GetSchemaSerializable();
                if (xs.Contains(dsSchema.TargetNamespace)) {
                    global::System.IO.MemoryStream s1 = new global::System.IO.MemoryStream();
                    global::System.IO.MemoryStream s2 = new global::System.IO.MemoryStream();
                    try {
                        global::System.Xml.Schema.XmlSchema schema = null;
                        dsSchema.Write(s1);
                        for (global::System.Collections.IEnumerator schemas = xs.Schemas(dsSchema.TargetNamespace).GetEnumerator(); schemas.MoveNext(); ) {
                            schema = ((global::System.Xml.Schema.XmlSchema)(schemas.Current));
                            s2.SetLength(0);
                            schema.Write(s2);
                            if ((s1.Length == s2.Length)) {
                                s1.Position = 0;
                                s2.Position = 0;
                                for (; ((s1.Position != s1.Length) 
                                            && (s1.ReadByte() == s2.ReadByte())); ) {
                                    ;
                                }
                                if ((s1.Position == s1.Length)) {
                                    return type;
                                }
                            }
                        }
                    }
                    finally {
                        if ((s1 != null)) {
                            s1.Close();
                        }
                        if ((s2 != null)) {
                            s2.Close();
                        }
                    }
                }
                xs.Add(dsSchema);
                return type;
            }
        }
        
        /// <summary>
        ///Represents strongly named DataRow class.
        ///</summary>
        public partial class employeeRow : global::System.Data.DataRow {
            
            private employeeDataTable tableemployee;
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            internal employeeRow(global::System.Data.DataRowBuilder rb) : 
                    base(rb) {
                this.tableemployee = ((employeeDataTable)(this.Table));
            }
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public string name {
                get {
                    return ((string)(this[this.tableemployee.nameColumn]));
                }
                set {
                    this[this.tableemployee.nameColumn] = value;
                }
            }
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public string operator_code {
                get {
                    return ((string)(this[this.tableemployee.operator_codeColumn]));
                }
                set {
                    this[this.tableemployee.operator_codeColumn] = value;
                }
            }
        }
        
        /// <summary>
        ///Row event argument class
        ///</summary>
        public class employeeRowChangeEvent : global::System.EventArgs {
            
            private employeeRow eventRow;
            
            private global::System.Data.DataRowAction eventAction;
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public employeeRowChangeEvent(employeeRow row, global::System.Data.DataRowAction action) {
                this.eventRow = row;
                this.eventAction = action;
            }
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public employeeRow Row {
                get {
                    return this.eventRow;
                }
            }
            
            [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
            public global::System.Data.DataRowAction Action {
                get {
                    return this.eventAction;
                }
            }
        }
    }
}
namespace DataLayer.dsLogonTableAdapters {
    
    
    /// <summary>
    ///Represents the connection and commands used to retrieve and save data.
    ///</summary>
    [global::System.ComponentModel.DesignerCategoryAttribute("code")]
    [global::System.ComponentModel.DataObjectAttribute(true)]
    public partial class employeeTableAdapter : global::System.ComponentModel.Component {
        
        private global::System.Data.SqlClient.SqlDataAdapter _adapter;
        
        private global::System.Data.SqlClient.SqlConnection _connection;
        
        private global::System.Data.SqlClient.SqlCommand[] _commandCollection;
        
        private bool _clearBeforeFill;
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        public employeeTableAdapter() {
            this.ClearBeforeFill = true;
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        private global::System.Data.SqlClient.SqlDataAdapter Adapter {
            get {
                if ((this._adapter == null)) {
                    this.InitAdapter();
                }
                return this._adapter;
            }
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        internal global::System.Data.SqlClient.SqlConnection Connection {
            get {
                if ((this._connection == null)) {
                    this.InitConnection();
                }
                return this._connection;
            }
            set {
                this._connection = value;
                if ((this.Adapter.InsertCommand != null)) {
                    this.Adapter.InsertCommand.Connection = value;
                }
                if ((this.Adapter.DeleteCommand != null)) {
                    this.Adapter.DeleteCommand.Connection = value;
                }
                if ((this.Adapter.UpdateCommand != null)) {
                    this.Adapter.UpdateCommand.Connection = value;
                }
                for (int i = 0; (i < this.CommandCollection.Length); i = (i + 1)) {
                    if ((this.CommandCollection[i] != null)) {
                        ((global::System.Data.SqlClient.SqlCommand)(this.CommandCollection[i])).Connection = value;
                    }
                }
            }
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        protected global::System.Data.SqlClient.SqlCommand[] CommandCollection {
            get {
                if ((this._commandCollection == null)) {
                    this.InitCommandCollection();
                }
                return this._commandCollection;
            }
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        public bool ClearBeforeFill {
            get {
                return this._clearBeforeFill;
            }
            set {
                this._clearBeforeFill = value;
            }
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        private void InitAdapter() {
            this._adapter = new global::System.Data.SqlClient.SqlDataAdapter();
            global::System.Data.Common.DataTableMapping tableMapping = new global::System.Data.Common.DataTableMapping();
            tableMapping.SourceTable = "Table";
            tableMapping.DataSetTable = "employee";
            tableMapping.ColumnMappings.Add("name", "name");
            tableMapping.ColumnMappings.Add("operator_code", "operator_code");
            this._adapter.TableMappings.Add(tableMapping);
            this._adapter.DeleteCommand = new global::System.Data.SqlClient.SqlCommand();
            this._adapter.DeleteCommand.Connection = this.Connection;
            this._adapter.DeleteCommand.CommandText = "DELETE FROM [employee] WHERE (([operator_code] = @Original_operator_code))";
            this._adapter.DeleteCommand.CommandType = global::System.Data.CommandType.Text;
            global::System.Data.SqlClient.SqlParameter param = new global::System.Data.SqlClient.SqlParameter();
            param.ParameterName = "@Original_operator_code";
            param.DbType = global::System.Data.DbType.AnsiString;
            param.IsNullable = true;
            param.SourceColumn = "operator_code";
            param.SourceVersion = global::System.Data.DataRowVersion.Original;
            this._adapter.DeleteCommand.Parameters.Add(param);
            this._adapter.UpdateCommand = new global::System.Data.SqlClient.SqlCommand();
            this._adapter.UpdateCommand.Connection = this.Connection;
            this._adapter.UpdateCommand.CommandText = "UPDATE [employee] SET [name] = @name, [operator_code] = @operator_code WHERE (([o" +
                "perator_code] = @Original_operator_code));\r\nSELECT name, operator_code FROM empl" +
                "oyee WHERE (operator_code = @operator_code)";
            this._adapter.UpdateCommand.CommandType = global::System.Data.CommandType.Text;
            param = new global::System.Data.SqlClient.SqlParameter();
            param.ParameterName = "@name";
            param.DbType = global::System.Data.DbType.AnsiString;
            param.IsNullable = true;
            param.SourceColumn = "name";
            this._adapter.UpdateCommand.Parameters.Add(param);
            param = new global::System.Data.SqlClient.SqlParameter();
            param.ParameterName = "@operator_code";
            param.DbType = global::System.Data.DbType.AnsiString;
            param.IsNullable = true;
            param.SourceColumn = "operator_code";
            this._adapter.UpdateCommand.Parameters.Add(param);
            param = new global::System.Data.SqlClient.SqlParameter();
            param.ParameterName = "@Original_operator_code";
            param.DbType = global::System.Data.DbType.AnsiString;
            param.IsNullable = true;
            param.SourceColumn = "operator_code";
            param.SourceVersion = global::System.Data.DataRowVersion.Original;
            this._adapter.UpdateCommand.Parameters.Add(param);
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        private void InitConnection() {
            this._connection = new global::System.Data.SqlClient.SqlConnection();
            this._connection.ConnectionString = "Data Source=CRAIG-THINKPAD\\SQL2008;Initial Catalog=fx21st;Integrated Security=Tru" +
                "e;";
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        private void InitCommandCollection() {
            this._commandCollection = new global::System.Data.SqlClient.SqlCommand[1];
            this._commandCollection[0] = new global::System.Data.SqlClient.SqlCommand();
            this._commandCollection[0].Connection = this.Connection;
            this._commandCollection[0].CommandText = "SELECT        name, operator_code\r\nFROM            employee\r\nWHERE        (passwo" +
                "rd = @password)";
            this._commandCollection[0].CommandType = global::System.Data.CommandType.Text;
            global::System.Data.SqlClient.SqlParameter param = new global::System.Data.SqlClient.SqlParameter();
            param.ParameterName = "@password";
            param.DbType = global::System.Data.DbType.AnsiString;
            param.Size = 5;
            param.IsNullable = true;
            param.SourceColumn = "password";
            this._commandCollection[0].Parameters.Add(param);
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.ComponentModel.DataObjectMethodAttribute(global::System.ComponentModel.DataObjectMethodType.Fill, true)]
        public virtual int Fill(dsLogon.employeeDataTable dataTable, string password) {
            this.Adapter.SelectCommand = this.CommandCollection[0];
            if ((password == null)) {
                throw new global::System.ArgumentNullException("password");
            }
            else {
                this.Adapter.SelectCommand.Parameters[0].Value = ((string)(password));
            }
            if ((this.ClearBeforeFill == true)) {
                dataTable.Clear();
            }
            int returnValue = this.Adapter.Fill(dataTable);
            return returnValue;
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.ComponentModel.DataObjectMethodAttribute(global::System.ComponentModel.DataObjectMethodType.Select, true)]
        public virtual dsLogon.employeeDataTable GetData(string password) {
            this.Adapter.SelectCommand = this.CommandCollection[0];
            if ((password == null)) {
                throw new global::System.ArgumentNullException("password");
            }
            else {
                this.Adapter.SelectCommand.Parameters[0].Value = ((string)(password));
            }
            dsLogon.employeeDataTable dataTable = new dsLogon.employeeDataTable();
            this.Adapter.Fill(dataTable);
            return dataTable;
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        public virtual int Update(dsLogon.employeeDataTable dataTable) {
            return this.Adapter.Update(dataTable);
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        public virtual int Update(dsLogon dataSet) {
            return this.Adapter.Update(dataSet, "employee");
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        public virtual int Update(global::System.Data.DataRow dataRow) {
            return this.Adapter.Update(new global::System.Data.DataRow[] {
                        dataRow});
        }
        
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        public virtual int Update(global::System.Data.DataRow[] dataRows) {
            return this.Adapter.Update(dataRows);
        }
    }
}
namespace dsLogonUtil {
    using System;
    using System.Data;
    
    
    public partial class DesignerUtil {
        
        public static bool IsDesignTime() {
            // Determine if this instance is running against .NET Framework by using the MSCoreLib PublicKeyToken
            System.Reflection.Assembly mscorlibAssembly = typeof(int).Assembly;
            if ((mscorlibAssembly != null)) {
                if (mscorlibAssembly.FullName.ToUpper().EndsWith("B77A5C561934E089")) {
                    return true;
                }
            }
            return false;
        }
        
        public static bool IsRunTime() {
            // Determine if this instance is running against .NET Compact Framework by using the MSCoreLib PublicKeyToken
            System.Reflection.Assembly mscorlibAssembly = typeof(int).Assembly;
            if ((mscorlibAssembly != null)) {
                if (mscorlibAssembly.FullName.ToUpper().EndsWith("969DB8053D3322AC")) {
                    return true;
                }
            }
            return false;
        }
    }
}
