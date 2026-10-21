---
title: 'Introduction to Linux: **Scripting in Practice**'
author: Philipp Fruck & Pius Walter
theme:
  path: ../themes/dhbw_mannheim_dark.yml
---

Scripting
===

<!-- column_layout: [3, 3] -->

<!-- column: 0 -->

# Goal of this lecture

- Learn practical scripting pitfalls and best practices
- Get familiar with editors and process/job control

# Why?

- Real-world scripts must handle errors and edge cases safely
- Editors and job control are daily tools for any Linux user

<!-- column: 1 -->

# Use Cases:

- Writing robust, production-ready scripts
- Managing long-running or background tasks
- Editing files directly on remote servers

<!-- end_slide -->

Processes and Job Control
===

# Key Commands

| Command  | Description                              | Example Usage                          |
| -------- | ---------------------------------------- | -------------------------------------- |
| `&`      | Run a command in the background          | `./long_running_command &`             |
| `Ctrl+Z` | Pause (suspend) a running process        | Press `Ctrl+Z` while running a command |
| `bg`     | Move a stopped job to the background     | `bg %1` (background job 1)             |
| `fg`     | Bring a background job to the foreground | `fg %3` (foreground job 3)             |
| `jobs`   | List all background jobs                 | `jobs`                                 |

# Examples

<!-- column_layout: [3, 3] -->

<!-- column: 0 -->

```bash
# Run a command in the background
$ long_running_task &
[1] 12345  # Job 1, PID 12345

# Suspend the process with Ctrl+Z
$ ^Z
[2]+ Stopped              long_running_task

# list background jobs
$ jobs
[1]-  Running                    long_running_task
[2]+  Stopped                    long_running_task
```

<!-- column: 1 -->

```bash
# Move the suspended process to the background
$ bg
[1]+ 12345 long_running_task &

# Bring the process to the foreground
$ fg
long_running_task

# Bring the second background process in the foreground
$ fg %3
other_task
```

<!-- end_slide -->

Thank you!
===

Thank you for your attention!

Don't forget the feedback in Moodle please!
