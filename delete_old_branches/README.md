# 🧹delete_old_branches

This script helps you safely delete **old local Git branches** based on **last commit age** and **branch name prefix**.

Useful for keeping your local repo clean and relevant.

---

## 🚀 Usage

```bash
cp delete_old_branches.sh /path/to/your/project/delete_old_branches.sh
./delete_old_branches.sh "<time>" ["prefix1 prefix2 ..."]
```


## 🔧 Examples
```bash
# Delete branches older than 4 months that start with 'feature/' or 'fix/'
./delete_old_branches.sh "4 months" "feature/ fix/"

# Delete branches older than 6 weeks that start with 'hotfix/'
./delete_old_branches.sh "6 weeks" "hotfix/"

# Delete branches older than 2 months that match exactly 'learn'
./delete_old_branches.sh "2 months" "learn"

# Default: uses "feature/" prefix if none is provided
./delete_old_branches.sh "3 months"
```

## 🕓 Allowed Times
| Format     | Meaning               |
| ---------- | --------------------- |
| `1 day`    | 1 day ago             |
| `3 days`   | 3 days ago            |
| `1 week`   | 7 days ago            |
| `2 weeks`  | 14 days ago           |
| `1 month`  | 1 calendar month ago  |
| `4 months` | 4 calendar months ago |
| `1 year`   | 1 calendar year ago   |
| `2 years`  | 2 calendar years ago  |


## 📦 Install Globally

```bash
# Copy and rename the script to remove .sh extension
cp delete_old_branches.sh delete_old_branches

# Make it executable
chmod +x delete_old_branches
# Move it to a directory in your PATH
sudo mv delete_old_branches /usr/local/bin/

# Usage
delete_old_branches "6 weeks" "hotfix/"
delete_old_branches "2 months" "learn"
delete_old_branches "3 months" 
```


## 👥 Contributors
* [Agung Yuliyanto](https://github.com/agung96tm)
