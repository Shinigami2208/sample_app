const IMAGE_MAX_SIZE = 5;
const DIVIDE_SIZE = 1024;

$('#micropost_image').bind('change', function() {
  let size_in_megabytes = this.files[0].size/DIVIDE_SIZE/DIVIDE_SIZE;
  if (size_in_megabytes > IMAGE_MAX_SIZE) {
      alert(I18n.t('shared.micropost_form.image_size_validate'));
      this.value = null;
  }
});
