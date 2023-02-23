IMAGE_NAME=asweb01
CONTAINER_NAME=asweb01

build:
	@echo "build image ${IMAGE_NAME}" ; \
	docker build -t ${IMAGE_NAME} . ; \
	echo "done."

up:
	@echo "up container ${CONTAINER_NAME} from image ${IMAGE_NAME}" ; \
	docker run --name ${CONTAINER_NAME} ${IMAGE_NAME} ; \
	echo "done."

remove:
	@echo "remove container ${CONTAINER_NAME}" ; \
	docker rm ${CONTAINER_NAME} ; \
	echo "done."

terminal:
	@echo "open terminal in the container ${CONTAINER_NAME}" ; \
	docker run -ti ${CONTAINER_NAME} bash ; \
	echo "done."

