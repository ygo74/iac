msg="Hello World"
print(msg)

msg = msg.capitalize()
print(msg)

dict={}
dict["dev"]={}
dict["uat"]={}

dict["dev"]["applications"]={}

print(dict)

list=[
    {
        "server_name": "test1",
        "server_location": "loc1",
        "server_role": "role1"
    },
    {
        "server_name": "test2",
        "server_location": "loc2",
        "server_role": "role2"
    }
]

print(list[0]["server_location"])