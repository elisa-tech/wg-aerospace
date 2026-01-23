# SPDX-License-Identifier: MIT

import os
import glob
import sys

def extract_attendance(file_path):
    with open(file_path, 'r') as file:
        in_attendance_section = False
        attendees = set()
        for line in file:
            if "Attended this meeting" in line:
                in_attendance_section = True
                continue
            if "Attended recently in the past" in line:
                break
            if in_attendance_section and line.strip():
                name = line.strip().split(" - ")[0].strip()
                attendees.add(name)
        return attendees

def main(year):
    unique_attendees = set()
    for file_path in glob.glob(f"*{year}*.md"):
        attendees = extract_attendance(file_path)
        unique_attendees.update(attendees)

    if unique_attendees:
        print(f"Total unique attendees: {len(unique_attendees)}")
        print("Unique attendees:")
        for attendee in unique_attendees:
            print(attendee)
    else:
        print("No attendance data found.")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python get_attendance.py <year>")
        sys.exit(1)
    year = sys.argv[1]
    main(year)