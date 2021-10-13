plugins {
	id("nebula.dependency-lock") version "12.1.0"
}

subprojects {
	apply(plugin = "nebula.dependency-lock")

	tasks.register<DependencyReportTask>("dependenciesForAll")
}
