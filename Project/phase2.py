import json
import copy
import pandas as pd
from colorama import Fore

# pip install pandas
# pip install colorama
# pip install Jinja2

FILE_NAME = "prime_asm.json"
main_string = ""


def find_start_node(json_data):
    for key in json_data.keys():
        key_data = json_data[key]
        for inner_key in key_data:
            if inner_key == "start" and key_data[inner_key]:
                return key, key_data
    return None, None


def find_star_node(json_data):
    for key in json_data.keys():
        key_data = json_data[key]
        for inner_key in key_data:
            if inner_key == "star" and key_data[inner_key]:
                return key, key_data
    return None, None


def find_all_variables(json_data):
    to_return = []
    for key in json_data.keys():
        if key.startswith("oval"):
            key_data = json_data[key]
            if "star" not in key_data.keys():
                for oval_statement in key_data["statements"]:
                    oval_statement_separated = oval_statement.split()
                    if oval_statement_separated[0] not in to_return:
                        to_return.append(oval_statement_separated[0])
    return to_return


def get_number_of_states(json_data):
    counter = 0
    own_states = []
    for key in json_data.keys():
        if key.startswith("rectangle"):
            counter += 1
            own_states.append(key)
    return counter, own_states


def find_next_node_int_based(json_data, next_id):
    for key in json_data.keys():
        key_data = json_data[key]
        for inner_key in key_data:
            if inner_key == "id" and key_data[inner_key] == next_id:
                return key, key_data
    return None, None


def get_state_nodes(json_data):
    to_return = dict()
    to_return_relation = dict()
    checked_list = list()
    current_node = None

    for key in json_data.keys():
        key_data = json_data[key]
        if key.startswith("rectangle"):
            current_node = key
            if key not in to_return.keys():
                to_return[key] = []
                next_node_key, _ = find_next_node_int_based(json_data, key_data["next"])
                if next_node_key not in checked_list:
                    to_return[key].append(next_node_key)
                    checked_list.append(next_node_key)
            if key not in checked_list:
                checked_list.append(key)
        elif key.startswith("oval"):
            if key not in checked_list:
                to_return[current_node].append(key)
            next_node_key, _ = find_next_node_int_based(json_data, key_data["next"])
            if next_node_key not in checked_list and not next_node_key.startswith("rectangle"):
                to_return[current_node].append(next_node_key)
                checked_list.append(next_node_key)
            elif next_node_key.startswith("rectangle"):
                to_return_relation[key] = next_node_key
        elif key.startswith("diamond"):
            if key not in checked_list:
                to_return[current_node].append(key)
            next_node_key_positive, _ = find_next_node_int_based(json_data, key_data["next_positive"])
            next_node_key_negative, _ = find_next_node_int_based(json_data, key_data["next_negative"])
            if next_node_key_positive not in checked_list and not next_node_key_positive.startswith("rectangle"):
                to_return[current_node].append(next_node_key_positive)
                checked_list.append(next_node_key_positive)
            elif next_node_key_positive.startswith("rectangle"):
                to_return_relation[key + "+"] = next_node_key_positive
            if next_node_key_negative not in checked_list and not next_node_key_negative.startswith("rectangle"):
                to_return[current_node].append(next_node_key_negative)
                checked_list.append(next_node_key_negative)
            elif next_node_key_negative.startswith("rectangle"):
                to_return_relation[key + "-"] = next_node_key_negative

    return to_return, to_return_relation


def concat_conditions(json_data, diamonds_in_state):
    concat = ""
    for name in diamonds_in_state:
        if name.startswith("diamond"):
            node_data = json_data[name]
            concat += node_data["statements"]
            concat += " && "
    if len(concat) > 0:
        concat = concat[:len(concat)-4]
    return concat


def concat_statements(json_data, ovals_in_state, number_of_t):
    concat = ""
    for name in ovals_in_state:
        if name.startswith("oval"):
            node_data = json_data[name]
            for j in node_data["statements"]:
                concat += "\t" * number_of_t
                concat += j
                concat += ";\n"
    return concat


def get_next_state(present_state, def_member, def_relation, states_in_list):
    present_state_name = states_in_list[present_state]
    nodes = def_member[present_state_name]
    to_return = None
    for j in nodes:
        if j in def_relation.keys():
            to_return = def_relation[j]
        if j+"+" in def_relation.keys():
            to_return = def_relation[j+"+"]
        if j+"-" in def_relation.keys():
            to_return = def_relation[j+"-"]
    for j in range(len(states_in_list)):
        if states_in_list[j] == to_return:
            return j
    return -1


with open(FILE_NAME) as json_file:
    data = json.load(json_file)

    # first we should specify input and output of the module
    for_last_part = []
    main_string += "module MainModule(\n"
    first_node_key, first_node_data = find_start_node(data)
    star_node_key, star_node_data = find_star_node(data)
    main_variables_list = []
    for statement in star_node_data["statements"]:
        separated = statement.split()
        main_variables_list.append(separated[0])
    all_variables_list = find_all_variables(data)
    for variable in main_variables_list:
        if variable in all_variables_list:
            main_string += f"\toutput reg [31:0] {variable},\n"
            for_last_part.append(variable)
        else:
            main_string += f"\tinput wire [31:0] {variable},\n"
    main_string += f"\tinput wire clk,\n"
    main_string += f"\tinput wire reset\n"
    main_string += ");\n"

    # now we should create current state and next state
    number_of_states, own_states_in_data = get_number_of_states(data)
    main_string += f"\treg [{number_of_states}:0] current_state, next_state;\n"

    # now we should create other registers which are not in input or output
    for variable in all_variables_list:
        if variable not in main_variables_list:
            main_string += f"\toutput reg [31:0] {variable};\n"
            for_last_part.append(variable)

    # now we should start combination part
    member, relation = get_state_nodes(data)
    main_string += f"\talways @(*) begin\n"
    main_string += f"\t\tcase (current_state)\n"
    for i in range(number_of_states):
        main_string += f"\t\t{i}: begin\n"
        concat_condition = concat_conditions(data, member[own_states_in_data[i]])
        if len(concat_condition) > 0:
            main_string += f"\t\t\tif ({concat_condition}) begin\n"
            concat_statement = concat_statements(data, member[own_states_in_data[i]], 4)
            main_string += concat_statement
            next_state = get_next_state(i, member, relation, own_states_in_data)
            if next_state == -1:
                main_string += f"\t\t\t\tnext_state = {i};\n"
            else:
                main_string += f"\t\t\t\tnext_state = {next_state};\n"
            main_string += "\t\t\tend else begin\n"
            main_string += f"\t\t\t\tnext_state = {i};\n"
            main_string += "\t\t\tend\n"
        else:
            concat_statement = concat_statements(data, member[own_states_in_data[i]], 3)
            main_string += concat_statement
            next_state = get_next_state(i, member, relation, own_states_in_data)
            if next_state == -1:
                main_string += f"\t\t\tnext_state = {i};\n"
            else:
                main_string += f"\t\t\tnext_state = {next_state};\n"
        main_string += f"\t\tend\n"
    main_string += f"\t\tendcase\n"
    main_string += f"\tend\n"

    main_string += f"\talways @(posedge clk) begin\n"
    main_string += f"\t\tif (reset) begin\n"
    main_string += f"\t\t\tcurrent_state <= 0;\n"
    for i in for_last_part:
        main_string += f"\t\t\t{i} <= 0;\n"
    main_string += f"\t\tend else begin\n"
    main_string += f"\t\t\tcurrent_state <= next_state;\n"
    main_string += f"\t\tend\n"
    main_string += f"\tend\n"

    main_string += f"endmodule\n"

    f = open("output.v", "w")
    f.write(main_string)
    f.close()
