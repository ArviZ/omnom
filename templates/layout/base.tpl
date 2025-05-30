<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Omnom</title>
    <link rel="stylesheet" href="{{ BaseURL "/static/css/bulma.css" }}" />
    <link rel="stylesheet" href="{{ BaseURL "/static/css/style.css" }}" />
    <link rel="icon" type="image/png" href="{{ BaseURL "/static/icons/omnom.png" }}" sizes="128x128">

    {{ block "head" . }} {{ end }}
</head>
<body id="omnom-webapp">
<div class="webapp__content {{ block "content-class" . }}{{ end }}">
<nav class="navbar {{ block "content-class" . }}{{ end }}" role="navigation" aria-label="main navigation">
  <div class="navbar__container{{ if ne .Page "index" }} shadow-bottom{{ end }}">
    <div class="navbar-brand is-size-4">
      <a class="navbar__logo" href="{{ URLFor "Index" }}"><span>om</span><span class="text--primary">nom</span> </a>
      <label for="nav-toggle-state" role="button" class="navbar-burger burger has-text-black" aria-label="menu" aria-expanded="false">
        <span aria-hidden="true"></span>
        <span aria-hidden="true"></span>
        <span aria-hidden="true"></span>
        <span aria-hidden="true"></span>
      </label>
    </div>
    <input type="checkbox" id="nav-toggle-state" />

    <div id="navbar-menu" class="navbar-menu is-size-5">
      <div class="navbar-start">
        <a href="{{ URLFor "Index" }}" class="navbar-item{{ if or (eq .Page "index") (eq .Page "dashboard") }} is-active{{ end }}">Home</a>
        {{ if .User }}
          <a href="{{ URLFor "My bookmarks" }}" class="navbar-item{{ if eq .Page "my-bookmarks" }} is-active{{ end }}">My bookmarks</a>
        {{ end }}
        <a href="{{ URLFor "Public bookmarks" }}" class="navbar-item{{ if eq .Page "bookmarks" }} is-active{{ end }}">Public bookmarks</a>
        {{ if (and .User .AllowBookmarkCreation) }}
          <a href="{{ URLFor "Create bookmark form" }}" class="navbar-item{{ if eq .Page "create-bookmark" }} is-active{{ end }}">Create bookmark</a>
        {{ end }}
        <a href="{{ URLFor "Snapshots" }}" class="navbar-item{{ if eq .Page "snapshots" }} is-active{{ end }}">Snapshots</a>
      </div>
      <div class="navbar-end">
        {{ if .User }}
            <a href="{{ URLFor "Profile" }}" class="navbar-item"><i class="fas fa-user"></i> &nbsp; {{ .User.Username }}</a>
              {{ if .AllowManualLogin }}
                <div class="navbar-item"><a href="{{ URLFor "Logout" }}" class="button is-outlined is-info">Logout</a></div>
              {{ end }}
        {{ else if .AllowManualLogin }}
            <div class="navbar-item"><a href="{{ URLFor "Login" }}" class="button is-outlined is-info">Login</a></div>
            {{ if not .DisableSignup }}<div class="navbar-item"><a href="{{ URLFor "Signup" }}" class="button is-outlined is-info">Signup</a></div>{{ end }}
        {{ end }}
      </div>
    </div>
  </div>
</nav>

    {{ if .Error }}
    <div class="section">{{ block "error" .Error }}{{ end }}</div>
    {{ end }}
    {{ if .Warning }}
    <div class="section">{{ block "warning" .Warning }}{{ end }}</div>
    {{ end }}
    {{ if .Info }}
    <div class="section">{{ block "info" .Info }}{{ end }}</div>
    {{ end }}
{{block "full-content" . }}
<div class="section webapp__main-container">
    <div class="bd-main-container container">
        {{ block "content" . }}{{ end }}
    </div>
</div>
{{ end }}
{{ if (not .hideFooter) }}
<footer class="footer">
  <div class="container">
    <div class="content has-text-centered py-4">
      <p>Omnom © 2025</p>
      <span>
          <a href="{{ URLFor "API" }}">API</a>
          &#8226; <a href="https://github.com/asciimoo/omnom">GitHub</a>
          &#8226; <a href="https://addons.mozilla.org/en-US/firefox/addon/omnom/">Firefox extension</a>
          &#8226; <a href="https://chrome.google.com/webstore/detail/omnom/nhpakcgbfdhghjnilnbgofmaeecoojei">Chrome extension</a>
          &#8226; <a href="https://github.com/asciimoo/omnom/wiki">Wiki</a>
          <br />
          <a href="{{ AddURLParam .URL "format=json" }}">View as JSON</a>
      </span>
    </div>
  </div>
</footer>
{{ end }}
</div>
</body>
</html>

{{ define "error" }}
<article class="message is-danger container is-size-5">
  <div class="message-body">{{ . | ToHTML }}</div>
</article>
{{ end }}

{{ define "warning" }}
<article class="message is-warning container is-size-5">
  <div class="message-header">
    <p>Warning</p>
  </div>
  <div class="message-body">{{ . | ToHTML }}</div>
</article>
{{ end }}

{{ define "info" }}
<article class="message is-info container is-size-5">
  <div class="message-body">{{ . | ToHTML }}</div>
</article>
{{ end }}


{{ define "note" }}
<article class="message is-info container is-size-5">
  <div class="message-header">
    <p>Note</p>
  </div>
  <div class="message-body">{{ . | ToHTML }}</div>
</article>
{{ end }}

{{ define "bookmark" }}
<div class="media bookmark__container">
    <div class="bookmark__header">
      <div class="bookmark__title">
        <div class="bookmark__favicon">
            <span class="icon">
            {{ if .Bookmark.Favicon }}
              <img src="{{ .Bookmark.Favicon | ToURL }}" alt="favicon" />
            {{ end }}
            </span>
        </div>
          <h4 class="title">
              <a href="{{ .Bookmark.URL }}" target="_blank">
                {{ .Bookmark.Title }}
              </a>
              <p class="is-size-7 has-text-grey has-text-weight-normal">
                  {{ Truncate .Bookmark.URL 100 }}<br />
                  <span class="has-text-black">{{ .Bookmark.CreatedAt | ToDate }}</span>
                <a href="{{ if or (eq $.Page "bookmarks") (ne $.Bookmark.UserID $.UID) }}{{ URLFor "Public bookmarks" }}{{ else }}{{ URLFor "My bookmarks" }}{{ end }}?user={{ .Bookmark.User.Username }}">@{{ .Bookmark.User.Username }}</span></a>
                {{ if .Bookmark.Tags }}
                <span class="bookmark__tags">
                    {{ range .Bookmark.Tags }}
                        <a href="{{ if or (eq $.Page "bookmarks") (ne $.Bookmark.UserID $.UID) }}{{ URLFor "Public bookmarks" }}{{ else }}{{ URLFor "My bookmarks" }}{{ end }}?tag={{ .Text }}"><span class="tag is-primary">{{ .Text }}</span></a>
                    {{ end }}
                </span>
                {{ end }}
              </p>
          </h4>
      </div>
      <div class="bookmark__actions">
        {{ if .Bookmark.Snapshots }}
          <details>
              <summary>
                  Snapshots <span class="bookmark__snapshot-count">({{len .Bookmark.Snapshots}})</span>
              </summary>
              <div>
                  {{ block "snapshots" KVData "Snapshots" .Bookmark.Snapshots "IsOwn" (eq .Bookmark.UserID .UID) "CSRF" .CSRF }}{{ end }}
              </div>
          </details>
          {{ end }}
        {{ if .Bookmark.Notes }}
        <details>
          <summary>
            Notes
          </summary>
          <div>
              <p class="has-text-black">{{ .Bookmark.Notes }}</p>
          </div>
        </details>
        {{ end }}
          <span class="tag is-light">{{ if .Bookmark.Public }}public{{ else }}private{{ end }}</span>
          <a href="{{ URLFor "Bookmark" }}?id={{ .Bookmark.ID }}">
              <i class="fas fa-eye"></i>
          </a>
          {{ if eq .UID .Bookmark.UserID }}
          <a href="{{ URLFor "Edit bookmark" }}?id={{ .Bookmark.ID }}">
              <i class="fas fa-pencil-alt"></i>
          </a>
          <form method="post" action="{{ URLFor "Delete bookmark" }}">
              <button class="button is-white" type="submit" value="Delete this bookmark" >
                  <span class="icon is-small"><i class="fas fa-trash"></i></span>
              </button>
              <input type="hidden" name="id" value="{{ .Bookmark.ID }}" />
              <input type="hidden" name="_csrf" value="{{ .CSRF }}" />
          </form>
          {{ end }}
          <!--<i class="fas fa-heart"></i>
          <i class="fas fa-share-alt"></i>-->
      </div>
    </div>
</div>
{{ end}}

{{ define "snapshots" }}
    {{ range $i,$s := .Snapshots }}
    <div class="snapshot__link">
      <div>
        <a href="{{ URLFor "Snapshot" }}?sid={{ $s.Key }}&bid={{ $s.BookmarkID }}">
          <span class="snapshot__date">{{ $s.CreatedAt | ToDate }}</span>
          <span class="snapshot__title">
          {{if $s.Title}}{{ $s.Title }}{{else}}snapshot #{{ $i }}{{end}}
          </span>
        </a>
      </div>
      <div class="bookmark__actions">
          {{ if $.IsOwn }}
          <i class="fas fa-pencil-alt"></i>
          <form method="post" action="{{ URLFor "Delete snapshot" }}">
              <input type="hidden" name="bid" value="{{ $s.BookmarkID }}" />
              <input type="hidden" name="_csrf" value="{{ $.CSRF }}" />
              <input type="hidden" name="sid" value="{{ $s.ID }}" />
              <button class="snapshot__delete" type="submit">
                  <i class="fas fa-trash"></i>
              </button>
          </form>
          {{ end }}
      </div>
    </div>
    {{ end }}
{{ end }}

{{ define "paging" }}
<div class="columns is-centered">
    <div class="column is-narrow">
        {{ if and .Pageno (gt .Pageno 1) }}
        <a href="{{ AddURLParam .URL (printf "pageno=%d" (dec .Pageno)) }}" class="button is-primary is-medium"><span class="icon"><i class="fas fa-angle-left"></i></span><span>Previous page</span></a>
        {{ end }}
        {{ if .HasNextPage }}
        <a href="{{ AddURLParam .URL (printf "pageno=%d" (inc .Pageno)) }}" class="button is-primary is-medium"><span>Next page</span><span class="icon"><i class="fas fa-angle-right"></i></span></a>
        {{ end }}
    </div>
</div>
{{ end }}

{{ define "textFilter" }}
<div class="field is-horizontal">
    <div class="field-body">
        <div class="field">
            <div class="control has-icons-left has-icons-right">
                <input class="input" type="text" placeholder="Search" name="query" value="{{ .SearchParams.Q }}">
                 <span class="icon is-small is-left">
                <i class="fas fa-search"></i>
                </span>
                <span class="icon is-small is-right">
                <i class="fas fa-times-circle"></i>
                </span>
            </div>
        </div>
    </div>
</div>
{{end}}
{{define "searchParameters"}}
<div class="checkboxes">
    <label class="label" for="search_in_snapshot">
        <input class="switch is-rounded" value="true" type="checkbox" id="search_in_snapshot"  name="search_in_snapshot"{{ if .SearchParams.SearchInSnapshot }} checked="checked"{{ end }}>
        Search in snapshot content
    </label>
    <label class="label">
        <input class="switch is-rounded" value="true" type="checkbox" id="search_in_note" name="search_in_note"{{ if .SearchParams.SearchInNote }} checked="checked"{{ end }}>
        Search in notes
    </label>
    {{ if eq .Page "my-bookmarks" }}
    <label class="label">
        <input class="switch is-rounded" value="true" type="checkbox" id="public" name="public"{{ if .SearchParams.IsPublic }} checked="checked"{{ end }}>
        Only public bookmarks
    </label>
    {{ end }}
</div>
{{ end }}

{{ define "domainFilter" }}
<div class="field">
    <label class="label">Domain</label>
    <div class="control">
        <input class="input" type="text" placeholder="Domain.." name="domain" value="{{ .SearchParams.Domain }}">
    </div>
</div>
{{ end }}

{{ define "ownerFilter" }}
<div class="field">
<label class="label">Owner</label>
    <div class="control">
        <input class="input" type="text" placeholder="Username.." name="owner" value="{{ .SearchParams.Owner }}">
    </div>
</div>
{{ end }}

{{ define "tagFilter" }}
<div class="field">
<label class="label">Tags</label>
    <div class="control">
        <input class="input" type="text" placeholder="Tag.." name="tag" value="{{ .SearchParams.Tag }}">
    </div>
</div>
{{ end }}

{{ define "dateFilter" }}
<div class="field is-grouped is-grouped-multiline">
    <div class="control">
    <div class="field">
        <label class="label">Date from</label>
            <p class="control is-expanded">
                <input class="input" type="date" placeholder="YYYY.MM.DD" name="from" value="{{ .SearchParams.FromDate }}">
            </p>
        </div>
    </div>
    <div class="control">
        <div class="field">
        <label class="label">Date to</label>
            <p class="control is-expanded">
                <input class="input" type="date" placeholder="YYYY.MM.DD" name="to" value="{{ .SearchParams.ToDate }}">
            </p>
        </div>
    </div>
</div>
{{ end }}

{{ define "submit" }}
<div class="control">
    <input type="submit" name="submit" value="{{ . }}" class="button is-primary" />
</div>

{{ end }}
