import csv
invalid_users = []
invalid_user_count = 0
invalid_group_count = 0

#list of Default Users
valid_user_groups = {
    'root': ['root'],
    'daemon': ['daemon'],
    'bin': ['bin'],
    'sys': ['sys'],
    'sync': ['nogroup'],
    'games': ['games'],
    'man': ['man'],
    'lp': ['lp'],
    'mail': ['mail'],
    'news': ['news'],
    'uucp': ['uucp'],
    'proxy': ['proxy'],
    'www-data': ['www-data'],
    'backup': ['backup'],
    'list': ['list'],
    'irc': ['irc'],
    'gnats': ['gnats'],
    'nobody': ['nogroup'],
    '_apt': ['nogroup'],
    'systemd-network': ['systemd-network'],
    'systemd-resolve': ['systemd-resolve'],
    'messagebus': ['messagebus'],
    'systemd-timesync': ['systemd-timesync'],
    'pollinate': ['daemon'],
    'sshd': ['nogroup'],
    'syslog': ['syslog', 'adm'],
    'uuidd': ['uuidd'],
    'tcpdump': ['tcpdump'],
    'tss': ['tss'],
    'landscape': ['landscape'],
    'fwupd-refresh': ['fwupd-refresh'],
    'usbmux': ['plugdev'],    
    'lxd': ['users']
}

def parse_csv(file_path):
    user_groups = {}
    with open(file_path, newline='') as csvfile:
        reader = csv.reader(csvfile)
        next(reader)  # Skip the header row
        for row in reader:
            if row:  # Check if the row is not empty
                username = row[0]
                groups = row[1:]
                user_groups[username] = groups
    return user_groups

file_path = input("filepath to .csv file:")
file_path = "C:/Users/Nathan/Desktop/users_and_groups.csv"
user_groups = parse_csv(file_path)


#compare Dictionary
def compare_dictionaries(user_groups, valid_user_groups):
    global invalid_user_count, invalid_group_count, invalid_users

    for user, groups in user_groups.items():
        if user not in valid_user_groups:
            print(f"{user}: {groups} !!ADDED_USER!!")
            invalid_user_count += 1
            invalid_users.append(user)
        else:
            # Checking for groups that are in user_groups but not in valid_user_groups
            invalid_groups = [group for group in groups if group not in valid_user_groups[user]]
            if invalid_groups:
                print(f"{user}: {invalid_groups} !!ADD_GROUP!!")
                invalid_group_count += 1
                invalid_users.append(user)

# Example usage
print("\nINVALID USERS: [GROUPS]")
compare_dictionaries(user_groups, valid_user_groups)
print(f"\nInvalid Users:{invalid_user_count}\nInvalid Groups:{invalid_group_count}")
print(f"\nCheck on the fallowing useres: {invalid_users}")


# for user, groups in user_groups.items():
#     print(f"\t\'{user}\': {groups},")
