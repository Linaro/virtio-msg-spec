## README

Members of the [OASIS Virtual I/O Device (VIRTIO) TC](https://www.oasis-open.org/committees/virtio/) create and manage technical content in this TC GitHub repository ( [https://github.com/oasis-tcs/virtio-spec](https://github.com/oasis-tcs/virtio-spec) ) as part of the TC's chartered work (*i.e.*, the program of work and deliverables described in its [charter](https://www.oasis-open.org/committees/virtio/charter.php)).

OASIS TC GitHub repositories, as described in [GitHub Repositories for OASIS TC Members' Chartered Work](https://www.oasis-open.org/resources/tcadmin/github-repositories-for-oasis-tc-members-chartered-work), are governed by the OASIS [TC Process](https://www.oasis-open.org/policies-guidelines/tc-process), [IPR Policy](https://www.oasis-open.org/policies-guidelines/ipr), and other policies, similar to TC Wikis, TC JIRA issues tracking instances, TC SVN/Subversion repositories, etc. While they make use of public GitHub repositories, these TC GitHub repositories are distinct from [OASIS Open Repositories](https://www.oasis-open.org/resources/open-repositories), which are used for development of open source [licensed](https://www.oasis-open.org/resources/open-repositories/licenses) content.

### Description

This repository includes the [authoritative source](https://github.com/oasis-tcs/virtio-spec/releases) of the VIRTIO (Virtual I/O) Specification document. VIRTIO document describes the specifications of the "virtio" family of devices. These devices are found in virtual environments, yet by design they look like physical devices to the guest within the virtual machine — and this document treats them as such. This similarity allows the guest to use standard drivers and discovery mechanisms.

The purpose of virtio and this specification is that virtual environments and guests should have a straightforward, efficient, standard and extensible mechanism for virtual devices, rather than boutique per-environment or per-OS mechanisms.

### Contributions

As stated in this repository's [CONTRIBUTING file](https://github.com/oasis-tcs/virtio-spec/blob/master/CONTRIBUTING.md), contributors to this repository are expected to be Members of the OASIS virtio TC, for any substantive change requests. Anyone wishing to contribute to this GitHub project and [participate](https://www.oasis-open.org/join/participation-instructions) in the TC's technical activity is invited to join as an OASIS TC Member. Public feedback is also accepted, subject to the terms of the [OASIS Feedback License](https://www.oasis-open.org/policies-guidelines/ipr#appendixa).

### Licensing

Please see the [LICENSE](https://github.com/oasis-tcs/virtio-spec/blob/master/LICENSE.md) file for description of the license terms and OASIS policies applicable to the TC's work in this GitHub project. Content in this repository is intended to be part of the virtio TC's permanent record of activity, visible and freely available for all to use, subject to applicable OASIS policies, as presented in the repository [LICENSE](https://github.os-tcs/virtio-spec/blob/master/LICENSE.md) file.

### Further Description of this Repository

#### Building Instructions

Authoritative version of the specification is maintained in the TeX document format. PDF and HTML versions are made available for ease of use and review. In order to build the HTML and PDF versions of the spec you will need the TeX document production system. The easiest way to get it up and running is probably by installing [Tex-Live](https://www.tug.org/texlive/).\
Installation cheat sheet:

***Fedora:***
```bash
sudo dnf install texlive-scheme-full
```
***Ubuntu and other Debian derivatives:***
```bash
sudo apt-get install texlive-full
```
***OSX:***

OSX users don't need to install Tex-Live because they already have [MacTeX](http://www.tug.org/mactex/) installed.

The build process generates a ZIP package file including the original TeX sources, as well as HTML and PDF formatted versions of the specification.

***To generate the ZIP package, run:***
```bash
./makeall.sh
```
***Troubleshooting notes:***
  
PDFs of the specification can be generated with either MicroSoft's Core fonts for the Web: Arial and Courier New, or
Liberation fonts: Liberation Sans and Liberation Mono. Most systems come with one of these two variants included: should
you get an error message about missing fonts, you will need to downloads and install one of the above font packages.

#### Providing Feedback

Informal feedback is accepted through the **virtio-comment** mailing list, and is archived in [the mailing list archives](https://lore.kernel.org/virtio-comment/). To provide feedback, subscribe by sending mail to [virtio-comment+subscribe@lists.linux.dev](mailto:virtio-comment+subscribe@lists.linux.dev), then after confirming you agree to the IPR sending your feedback to [virtio-comment@lists.linux.dev](mailto:virtio-comment@lists.linux.dev). Note that only plain text part of the message is archived, and all attachments are stripped. Accordingly, messages sent to the mailing list should use `text/plain` encoding and not have any attachments.

The preferred form of providing feedback is in form of a **patch**. A patch can be generated and sent by cloning the spec repository, creating a commit, formatting it as a patch and then sending it. For example:

```bash
git clone [https://github.com/oasis-tcs/virtio-spec.git](https://github.com/oasis-tcs/virtio-spec.git)
# edit spec text, and save ...
git commit -a
```

Describe the proposed change, in the following format:

  > single line summary
  > 
  > detailed description, including motivation for the change
  >
  > Signed-off-by: Name <email>

then save and close the editor

```bash
git format-patch -o proposal1/ HEAD~1..
# generates a new directory proposal1/ and a file starting with 0001- ...
git send-email --to=virtio-comment@lists.linux.dev proposal1/0001-*
```

Optionally, you can use [git-publish](https://github.com/stefanha/git-publish) to submit a patch. This project already contains a *git-publish* profile that will configure some fields, e.g., *To* field with the right address. After you have installed *git-publish*, the procedure is the following:

```bash
git checkout master -b my-feature
# work on new commits, add your 'Signed-off-by' lines to each
git publish
# more work, rebase on master, ...
git publish # will send a v2
```

***When to use the virtio-comment mailing list:***

questions and change proposals for the Virtio specification, including the specification of basic functionality, transports and devices.

***When not to use the virtio-comment mailing list:***

questions and change proposals for Virtio drivers and devices implementing the specification. (please use the [virtio-dev mailing list](mailto:virtio-dev@lists.linux.dev) for this).

***To do:***
- send email preferably in text format (best for archiving).

***Not to do:***
- copy both virtio-dev and virtio-comment mailing lists (instead, pick one);
- send full copies of the virtio spec (in any format).

#### Note for TC Members

TC Members should review TC specific process rules under "Further Description of this Repository" in [https://github.com/oasis-tcs/virtio-admin](https://github.com/oasis-tcs/virtio-admin)

#### Implementation discussion

Implementation discussion takes place on the **virtio-dev** mailing list, and is archived in [the mailing list archives](https://lore.kernel.org/virtio-dev/). To participate in the discussion, subscribe by sending mail to
[virtio-dev+subscribe@lists.linux.dev](mailto:virtio-dev+subscribe@lists.linux.dev). After agreeing to the IPR, to participate in the discussion, send mail to [virtio-dev@lists.linux.dev](mailto:virtio-dev@lists.linux.dev). This is the correct list to copy on Linux virtio UAPI change proposals.

Note that only the plain text part of the message is archived, and all attachments are stripped. Accordingly, messages sent to the mailing list should use text/plain encoding and not have any attachments.

***When to use the virtio-dev mailing list:***

questions and change proposals for Virtio drivers and devices implementing the specification.

***When not to use the virtio-dev mailing list:***

questions and change proposals for the Virtio specification, including the specification of basic functionality, transports and devices (please use the [virtio-comment mailing list](mailto:virtio-comment@lists.linux.dev) for this).

***To do:***
- send email preferably in text format (best for archiving).

***Not to do:***
- copy both virtio-dev and virtio-comment mailing lists (instead, pick one).

#### Use of github issues

Note: according to the virtio TC rules, all official TC communication is taking place on one of the TC mailing lists. In particular, all comments must be provided on one of the TC mailing lists. Accordingly, the TC will not respond to comments provided in github issues: github issues are used solely to track integration of comments into the specification.\
To request a TC vote on resolving a specific comment:

1. Create a github issue, or edit an existing issue, with a short summary of the comment.
   The issue MUST specify the link to the latest proposal in the TC mailing list
   archives. *Note:* the link MUST be in the issue description itself - *not* in the comments.

2. Reply by email to the comment email, requesting that the TC vote on resolving the issue.
   The mail requesting the vote should include the following, on a line by itself:

   ```
   Fixes: https://github.com/oasis-tcs/virtio-spec/issues/NNN
   ```
   (NNN is the issue number)

   For example, you can use the following template when requesting the TC vote:

   ```
   Could please open a voting ballot for these changes?

   Fixes: https://github.com/oasis-tcs/virtio-spec/issues/NNN
   ```

3. Please make sure to allow time for review between posting a comment and asking for a vote.

#### TC standing rules

The TC adopted the following standing rule:\
*Minor cleanups, including editorial formatting changes, spelling and typo fixes can be committed directly into git for approval as part of the next specification approval ballot.*

1. To request such a commit, reply by email to the comment email, requesting that the issue is resolved under the minor cleanups standing rule.
2. Please make sure to allow time for review between posting a comment and asking for a commit.

### Contact

Please send questions or comments about [OASIS TC GitHub repositories](https://www.oasis-open.org/resources/tcadmin/github-repositories-for-oasis-tc-members-chartered-work)
to [Robin Cover](mailto:robin@oasis-open.org) and [Chet Ensign](mailto:chet.ensign@oasis-open.org). For questions about content in this repository, please contact the TC Chair or Co-Chairs
as listed on the the virtio TC's [home page](https://www.oasis-open.org/committees/virtio/).
