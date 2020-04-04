```bash
pip install ansible-inventory-grapher
pip install graphviz

sudo apt-get update
sudo apt install graphviz

ansible-inventory-grapher -i inventories/poc/ front_dev_1 -d test --format "test-front_dev_1.dot"

ansible-inventory-grapher -i inventories/poc/ all -d test --format "test-all.dot"

for f in test/*.dot ; do dot -Tpng -o test/`basename $f .dot`.png $f; done

```
