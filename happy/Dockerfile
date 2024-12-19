# Java 17 JDK 이미지 사용
FROM openjdk:17-jdk-slim

# JAR 파일 이름 지정
ARG JAR_FILE=build/libs/happy-0.0.1-SNAPSHOT.jar

# JAR 파일을 컨테이너로 복사
COPY ${JAR_FILE} app.jar

# JAR 파일 실행
ENTRYPOINT ["java", "-jar", "/app.jar"]
