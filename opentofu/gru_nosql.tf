#
# gru_nosql.tf
# 

resource "oci_nosql_table" "gru_pizza_table" {
    provider = oci.gru

    name = "pizza"
    compartment_id = var.root_compartment    
    
    ddl_statement = <<EOF
         CREATE TABLE IF NOT EXISTS pizza (
            id INTEGER GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1),
            name STRING,
            description STRING,
            image STRING,
            price NUMBER,
         PRIMARY KEY(id))
    EOF
        
    table_limits {        
        max_read_units = 5
        max_write_units = 5
        max_storage_in_gbs = 10               
    }
}

resource "oci_nosql_table" "gru_user_table" {
    provider = oci.gru

    name = "user"
    compartment_id = var.root_compartment    
    
    ddl_statement = <<EOF
         CREATE TABLE IF NOT EXISTS user (
            id INTEGER GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1),
            name STRING,
            email STRING,
            password STRING,            
         PRIMARY KEY(id))
    EOF
        
    table_limits {        
        max_read_units = 5
        max_write_units = 5
        max_storage_in_gbs = 10               
    }
}


resource "oci_nosql_table" "gru_order_table" {
    provider = oci.gru

    name = "user.order"
    compartment_id = var.root_compartment    
    
    ddl_statement = <<EOF
         CREATE TABLE IF NOT EXISTS user.order ( 
            order_id INTEGER GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1),             
            address JSON,
            pizza JSON,  
            total NUMBER,
            order_datetime TIMESTAMP(0),
            status ENUM(PREPARING,OUT_FOR_DELIVERY,DELIVERED,CANCELED) DEFAULT PREPARING,             
         PRIMARY KEY (order_id))
    EOF     
}