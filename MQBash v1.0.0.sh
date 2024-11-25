#This Library is designed to make using MySQL queries more convenient in a Bash Script environment.
#How long will we continue using echo for SQL queries...?

#Library Release Version : MQBash v1.0.0

# Usage
# This library does not require separate execution permissions.
# To apply it to your shell script, you can load the library file as shown below.
# Please code it at the top of your shell script if possible.

# ...blah blah...
#   source <library location>/MQBash.lib
# ...blah blah....

# Usage in the script is as follows:
# glb_fnc_MQBash "<query type>" "<table name>" "<column to apply>" "<condition>"

# Example of a select query:
#glb_fnc_MQBash "select" "table_humans" "my_age_column" "my_name_column = \"MQBash\" and my_life_column = \"still alive\""

# Example of an update query (the fourth parameter is the value to be updated):
#glb_fnc_MQBash "update" "table_humans" "my_age_column = \"32\"" "my_name_column = \"MQBash\" and my_life_column = \"still alive\"" "my_age_column = \"99\""

# Example of an insert query (the fourth parameter is the value to be inserted):
#glb_fnc_MQBash "insert" "table_humans" "my_name_column, my_age_column, my_life_column" "\"MQBash_Clone\", \"22\", \"Baby\""

# The delete query is not yet updated.


#library

#mysql connection information here
function glb_fnc_mysql_request()
{
    local loc_mysql_database="${1}"
    local loc_mysql_hostname="localhost"
    local loc_mysql_username="root"
    local loc_mysql_userpwd="<<my password here>>"

    mysql -h"${loc_mysql_hostname}" -u"${loc_mysql_username}" -p"${loc_mysql_userpwd}" "${loc_mysql_database}"
}

#request query here
function glb_fnc_MQBash()
{
    local loc_data_type="${1}"
    local loc_table_name="${2}"
    local loc_culumns="${3}"
    local loc_query_condition="${4}"
    local loc_database_name
    
    case "${loc_table_name}" in
        "<<your table name>>")
            loc_database_name="<<the table database name>>"
        ;;
        *)
            #call log2db
            echo "${loc_table_name} is Unknown Table"
            false
        ;;
    esac

    #query result here
    #sed 1d is remove culumm line on select query
    case ${loc_data_type} in
        "select")
            echo "${loc_data_type} ${loc_culumns} from ${loc_table_name} where ${loc_query_condition};" | glb_fnc_mysql_request "${loc_database_name}" | sed "1d"
        ;;
        "insert")
            echo "${loc_data_type} into ${loc_table_name} (${loc_culumns}) values (${loc_query_condition});" | glb_fnc_mysql_request "${loc_database_name}"
        ;;
        "update")
            echo "${loc_data_type} ${loc_table_name} set ${loc_query_condition} where ${loc_culumns}" | glb_fnc_mysql_request "${loc_database_name}"
        ;;
        *)
            echo "wrong query type -> ${loc_data_type}"
            false
        ;;
    esac
}

