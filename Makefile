PACKAGES = notesserver notesapi

test: clean test-local coverage

test-local:
	./manage.py test --settings=notesserver.settings.test --with-coverage --with-ignore-docstrings \
		--exclude-dir=notesserver/settings --cover-inclusive --cover-branches \
		--cover-html --cover-html-dir=build/coverage/html/ \
		--cover-xml --cover-xml-file=build/coverage/coverage.xml \
		$(foreach package,$(PACKAGES),--cover-package=$(package)) \
		$(PACKAGES)

run:
	./manage.py runserver 0.0.0.0:8042

shell:
	./manage.py shell

clean:
	coverage erase

quality:
	pep8 --config=.pep8 $(PACKAGES)
	pylint $(PACKAGES)

diff-coverage:
	diff-cover coverage/coverage.xml --html-report build/coverage/diff_cover.html

diff-quality:
	diff-quality --violations=pep8 --html-report build/coverage/diff_quality_pep8.html
	diff-quality --violations=pylint --html-report build/coverage/diff_quality_pylint.html

coverage: diff-coverage diff-quality

create-index:
	python manage.py create_index
