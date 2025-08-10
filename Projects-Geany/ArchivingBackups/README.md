README - ArchivingBackups project documentation (Tutoring).<br>
	12/9/23.	wmk.
<pre><code>
</code><pre>
##Modification History.
<pre><code>12/9/23.	wmk.	original document.
</code><pre>
##Document Sections.
<pre><code>Project Description - overall project description.
</code><pre>
##Project Description.
ArchivingBackups encapsulates backing up files from the computer-resident
Tutoring folders to a *tar* archive on a flash drive. The project shells all
depend upon environment variable *pathbase* having been defined.

"Standard" subsystem archiving shells RestartIncGeany, IncDumpGeany, ReloadGeany,
RestartIncProcs, IncDumpProcs, and ReloadProcs are not support in the Tutoring
subsystem. These operations are superfluous since they are covered by the
RestartIncTutor, IncDumpTutor, and ReloadTutor shells.
