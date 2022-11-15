default: 
	python3 cidr.py

fmt:
	black .

install:
	pip3 install --user -r requirements.txt &&\
	pip3 install --user -r requirements-dev.txt

lint:
	pylint script.py

test:
	python3 -m pytest -s -vv

.PHONY: \
	default \
	fmt \
	install	\
	lint \
	test