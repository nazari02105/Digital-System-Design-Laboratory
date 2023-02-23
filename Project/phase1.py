import json
import copy
import pandas as pd
from colorama import Fore
# pip install pandas
# pip install colorama
# pip install Jinja2

FILE_NAME = "prime_asm.json"


def find_start_node(json_data):
    for key in json_data.keys():
        key_data = json_data[key]
        for inner_key in key_data:
            if inner_key == "start" and key_data[inner_key]:
                return key, key_data
    return None, None


def find_next_node_dict_based(json_data, current_node_data):
    next_node_id = current_node_data["next"]
    for key in json_data.keys():
        key_data = json_data[key]
        for inner_key in key_data:
            if inner_key == "id" and key_data[inner_key] == next_node_id:
                return key, key_data
    return None, None


def find_next_node_int_based(json_data, next_id):
    for key in json_data.keys():
        key_data = json_data[key]
        for inner_key in key_data:
            if inner_key == "id" and key_data[inner_key] == next_id:
                return key, key_data
    return None, None


def oval_with_5_len_statement(variables_dict, separated_list):
    if separated_list[2].isdigit():
        first_value = int(separated_list[2])
    else:
        first_value = copy.deepcopy(variables_dict[separated_list[2]])
    if separated_list[4].isdigit():
        second_value = int(separated_list[4])
    else:
        second_value = copy.deepcopy(variables_dict[separated_list[4]])
    if separated_list[3] == '+':
        return first_value + second_value
    elif separated_list[3] == '-':
        return first_value - second_value
    elif separated_list[3] == '*':
        return first_value * second_value
    elif separated_list[3] == '/':
        return first_value / second_value
    elif separated_list[3] == '%':
        return first_value % second_value
    elif separated_list[3] == '<<':
        return first_value << second_value
    elif separated_list[3] == '>>':
        return first_value >> second_value
    elif separated_list[3] == '&':
        return first_value & second_value
    elif separated_list[3] == '|':
        return first_value | second_value
    elif separated_list[3] == '^':
        return first_value ^ second_value


def check_diamond_statement(variables_dict, separated_list):
    if separated_list[0].isdigit():
        first_value = int(separated_list[0])
    else:
        first_value = variables_dict[separated_list[0]]
    if separated_list[2].isdigit():
        second_value = int(separated_list[2])
    else:
        second_value = variables_dict[separated_list[2]]
    if separated_list[1] == '==':
        return first_value == second_value
    elif separated_list[1] == '!=':
        return first_value != second_value
    elif separated_list[1] == '>':
        return first_value > second_value
    elif separated_list[1] == '<':
        return first_value < second_value
    elif separated_list[1] == '>=':
        return first_value >= second_value
    elif separated_list[1] == '<=':
        return first_value <= second_value


variables = {}
number_of_ticks = 1
with open(FILE_NAME) as json_file:
    data = json.load(json_file)

    # first we should find start node
    first_node_key, first_node = find_start_node(data)
    if first_node is None:
        raise Exception("I can not find first node, please change json file")
    if first_node_key.startswith("rectangle"):
        state_name = first_node["name"]
    else:
        print(Fore.RED + "It is better to specify a rectangular node as the starting point")
        state_name = "-"

    # after finding first node, we should start algorithm
    current_node = copy.deepcopy(first_node)
    current_node_key = copy.deepcopy(first_node_key)
    while True:
        # first we should check if we are in stop point or not
        if "star" in current_node.keys() and current_node["star"]:
            print("we are in stop point")
            print("shall we continue?")
            shall_we_continue = input("type yes to continue or no to break the loop:\n")
            if shall_we_continue == "no":
                break
        if current_node_key.startswith("rectangle"):
            # in this part we should just go to next node
            state_name = current_node["name"]
            previous_node_key = copy.deepcopy(current_node_key)
            current_node_key, current_node = find_next_node_dict_based(data, current_node)
            if previous_node_key == current_node_key:
                raise Exception("can not find next node of: ", previous_node_key)
        elif current_node_key.startswith("oval"):
            # in this section we should do statements and after that, we should go to next node
            statements = current_node["statements"]
            for statement in statements:
                separated = statement.split()
                if len(separated) == 3 and separated[1] == '=':
                    if separated[2].isdigit():
                        variables[separated[0]] = int(separated[2])
                    else:
                        if separated[2] in variables.keys():
                            value = copy.deepcopy(variables[separated[2]])
                            variables[separated[0]] = value
                        else:
                            raise Exception("This variable is not defined")
                elif len(separated) == 5 and separated[1] == '=':
                    returned_value = oval_with_5_len_statement(variables, separated)
                    variables[separated[0]] = returned_value
            previous_node_key = copy.deepcopy(current_node_key)
            current_node_key, current_node = find_next_node_dict_based(data, current_node)
            if previous_node_key == current_node_key:
                raise Exception("can not find next node of: ", previous_node_key)
        elif current_node_key.startswith("diamond") and len(current_node["statements"].split()) == 3:
            boolean_result = check_diamond_statement(variables, current_node["statements"].split())
            previous_node_key = copy.deepcopy(current_node_key)
            if boolean_result:
                current_node_key, current_node = find_next_node_int_based(data, current_node["next_positive"])
            else:
                current_node_key, current_node = find_next_node_int_based(data, current_node["next_negative"])
            if previous_node_key == current_node_key:
                raise Exception("can not find next node of: ", previous_node_key)
        print("--------------------------------------------------------")
        dict_to_print = copy.deepcopy(variables)
        dict_to_print["tick"] = number_of_ticks
        dict_to_print["asmBlock"] = state_name
        dict_to_print["currentKey"] = previous_node_key
        df = pd.DataFrame(dict_to_print, index=[number_of_ticks])
        df.style.set_properties(**{'text-align': 'center'})
        print(df)
        number_of_ticks += 1
