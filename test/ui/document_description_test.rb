require_relative '../system_test_case'

# This class tests that user can select wiki format of document's description.
class DocumentDescriptionTest < Pwfmt::Testing::SystemTestCase
  setup do
    load_default_data
    sign_in_as_test_user
    create_project
  end

  test 'textile initially selected when format setting is textile' do
    Setting.text_formatting = 'textile'
    visit new_project_document_path(project_id: project_id)
    assert textile_selected?('pwfmt-select-document_description')
  end

  test 'markdown initially selected when format setting is markdown' do
    Setting.text_formatting = 'markdown'
    visit new_project_document_path(project_id: project_id)
    assert markdown_selected?('pwfmt-select-document_description')
  end

  test 'textile initially selected in index page when format setting is textile' do
    Setting.text_formatting = 'textile'
    visit project_documents_path(project_id: project_id)
    find('a.icon-add').click
    assert textile_selected?('pwfmt-select-document_description')
  end

  test 'markdown initially selected in index page when format setting is markdown' do
    Setting.text_formatting = 'markdown'
    visit project_documents_path(project_id: project_id)
    find('a.icon-add').click
    assert markdown_selected?('pwfmt-select-document_description')
  end

  test 'view as textile in show page when document is saved as textile' do
    save_document_as('textile')
    visit document_path(Document.first)
    assert textile_include?('content')
  end

  test 'view as markdown in show page when document is saved as markdown' do
    save_document_as('markdown')
    visit document_path(Document.first)
    assert markdown_include?('content')
  end

  test 'view as own format in index page when documents are saved with different format' do
    save_document_as('textile')
    save_document_as('markdown')
    visit project_documents_path(project_id: project_id)
    assert textile_include?('content')
    assert markdown_include?('content')
  end

  test 'textile selected when editing document saved as textile' do
    Setting.text_formatting = 'markdown'
    save_document_as('textile')
    visit edit_document_path(Document.first)
    assert textile_selected?('pwfmt-select-document_description')
  end

  test 'markdown selected when editing document saved as markdown' do
    Setting.text_formatting = 'textile'
    save_document_as('markdown')
    visit edit_document_path(Document.first)
    assert markdown_selected?('pwfmt-select-document_description')
  end

  test 'update format to markdown from textile' do
    Setting.text_formatting = 'textile'
    save_document_as('textile')
    doc = Document.first
    visit edit_document_path(doc)
    select_markdown('pwfmt-select-document_description')
    find_by_id('document_description').set(markdown_text)
    find("#edit_document_#{doc.id} input[name=commit]").click
    visit document_path(doc)
    assert markdown_include?('content')
  end

  test 'update format to textile from markdown' do
    Setting.text_formatting = 'markdown'
    save_document_as('markdown')
    doc = Document.first
    visit edit_document_path(doc)
    select_textile('pwfmt-select-document_description')
    find_by_id('document_description').set(textile_text)
    find("#edit_document_#{doc.id} input[name=commit]").click
    visit document_path(doc)
    assert textile_include?('content')
  end

  test 'preview by selected format' do
    visit new_project_document_path(project_id: project_id)
    select_markdown('pwfmt-select-document_description')
    find_by_id('document_description').set(markdown_text)
    find('#new_document a.tab-preview').click
    wait_for_preview
    assert markdown_include?('preview_document_description')
    find('#new_document a.tab-edit').click
    select_textile('pwfmt-select-document_description')
    find_by_id('document_description').set(textile_text)
    find('#new_document a.tab-preview').click
    wait_for_preview
    assert textile_include?('preview_document_description')
  end
end
